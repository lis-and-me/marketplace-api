module Wishlist
  class CreateService
    def self.call(user:, product_id:)
      new(user:, product_id:).call
    end

    def initialize(user:, product_id:)
      @user = user
      @product_id = product_id
    end

    def call
      product = Product.find(@product_id)

      WishlistItem.create!(
        user: @user,
        product: product
      )
    end
  end
end