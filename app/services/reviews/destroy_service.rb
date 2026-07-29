module Reviews
  class DestroyService
    def self.call(review)
      new(review).call
    end

    def initialize(review)
      @review = review
    end

    def call
      product = review.product
      rating = review.rating

      ActiveRecord::Base.transaction do
        review.destroy!
        rating.destroy! if rating.present?

        Products::RecalculateRatingService.call(
          product: product
        )
      end
    end

    private

    attr_reader :review
  end
end