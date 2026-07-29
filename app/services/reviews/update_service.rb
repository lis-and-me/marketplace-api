module Reviews
  class UpdateService
    def self.call(review:, params:)
      new(review, params).call
    end

    def initialize(review, params)
      @review = review
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        review.rating.update!(
          score: params[:score]
        )

        review.update!(
          comment: params[:comment],
          status: :pending
        )

        review.product.update!(
          average_rating: review.product.ratings.average(:score).to_f.round(2),
          reviews_count: review.product.ratings.count
        )
      end

      review
    end

    private

    attr_reader :review, :params
  end
end