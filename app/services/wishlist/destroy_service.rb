module Wishlist
  class DestroyService
    def self.call(user:, product_id:)
      new(user:, product_id:).call
    end

    def initialize(user:, product_id:)
      @user = user
      @product_id = product_id
    end

    def call
      wishlist_item = WishlistItem.find_by!(
        user: @user,
        product_id: @product_id
      )

      wishlist_item.destroy!

      wishlist_item
    end
  end
end