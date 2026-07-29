module Reviews
  class CreateService
    def self.call(user:, params:)
      new(user, params).call
    end

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      product = Product.find(params[:product_id])

      validate_purchase!(product)
      validate_unique_review!(product)

      ActiveRecord::Base.transaction do
        rating = Rating.create!(
          user: user,
          product: product,
          score: params[:score].to_i
        )

        review = Review.create!(
          user: user,
          product: product,
          rating: rating,
          comment: params[:comment],
          status: :pending
        )

        Products::RecalculateRatingService.call(
          product: product
        )

        review
      end
    end

    private

    attr_reader :user, :params

    def validate_purchase!(product)
      purchased = OrderItem
                    .joins(:order)
                    .where(product: product)
                    .where(
                      orders: {
                        user_id: user.id,
                        status: Order.statuses[:delivered]
                      }
                    )
                    .exists?

      return if purchased

      review = Review.new

      review.errors.add(
        :base,
        "You must purchase this product before reviewing it."
      )

      raise ActiveRecord::RecordInvalid.new(review)
    end

    def validate_unique_review!(product)
      existing_review = Review.find_by(
        user: user,
        product: product
      )

      return unless existing_review

      existing_review.errors.add(
        :base,
        "Ya has escrito una reseña para este producto."
      )

      raise ActiveRecord::RecordInvalid.new(existing_review)
    end
  end
end