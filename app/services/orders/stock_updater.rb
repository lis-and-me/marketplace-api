module Orders
  class StockUpdater
    def self.call(order:)
      new(order).call
    end

    def initialize(order)
      @order = order
    end

    def call
      @order.order_items.includes(:product).find_each do |item|
        product = item.product

        raise ActiveRecord::RecordNotFound,
              "Product #{item.product_id} not found" if product.nil?

        product.with_lock do
          if product.stock < item.quantity
            raise Orders::InsufficientStockError,
                  "Insufficient stock for '#{product.name}'."
          end

          stock_before = product.stock
          stock_after = stock_before - item.quantity

          product.update!(
            stock: stock_after
          )

          Inventory::CreateMovementService.call(
            product: product,
            order: @order,
            quantity: item.quantity,
            movement_type: :purchase,
            stock_before: stock_before,
            stock_after: stock_after,
            note: "Order ##{@order.id}"
          )
        end
      end

      true
    end
  end
end