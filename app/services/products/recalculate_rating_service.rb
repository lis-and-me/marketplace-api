module Products
  class RecalculateRatingService
    def self.call(product:)
      new(product).call
    end

    def initialize(product)
      @product = product
    end

    def call
      approved_ratings =
        Rating
          .joins(:review)
          .where(
            product: @product,
            reviews: {
              status: Review.statuses[:approved]
            }
          )

      @product.update!(
        average_rating:
          approved_ratings.average(:score).to_f.round(2),
        reviews_count:
          approved_ratings.count
      )

      @product
    end
  end
end