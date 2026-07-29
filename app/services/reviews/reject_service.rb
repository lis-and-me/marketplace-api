module Reviews
  class RejectService
    def self.call(review)
      new(review).call
    end

    def initialize(review)
      @review = review
    end

    def call
      ActiveRecord::Base.transaction do
        review.update!(
          status: :rejected
        )

        Products::RecalculateRatingService.call(
          product: review.product
        )

        review
      end
    end

    private

    attr_reader :review
  end
end