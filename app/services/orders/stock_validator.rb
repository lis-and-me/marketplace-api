module Orders
  class StockValidator


    def self.call(cart:)
      new(cart).call
    end

    def initialize(cart)
      @cart = cart
    end

    def call
      @cart.cart_items.includes(:product).find_each do |item|
        product = item.product

        raise ActiveRecord::RecordNotFound, "Product #{item.product_id} not found" if product.nil?

        if product.respond_to?(:deleted_at) && product.deleted_at.present?
          raise ActiveRecord::RecordNotFound,
                "Product '#{product.name}' is no longer available"
        end

        if product.stock < item.quantity
          raise Orders::InsufficientStockError,
      "Insufficient stock for '#{product.name}'. Requested #{item.quantity}, available #{product.stock}."
        end
      end

      true
    end
  end
end