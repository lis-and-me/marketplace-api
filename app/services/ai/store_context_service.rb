module Ai
  class StoreContextService
    def self.call
      new.call
    end

    def call
      {
        generated_at: Time.current,
        users: users,
        products: products,
        orders: orders,
        reviews: reviews,
        inventory: inventory,
        top_products: top_products
      }
    end

    private

    def users
      {
        total: User.count,
        active: User.active.count,
        customers: User.user.count
      }
    end

    def products
      {
        total: Product.count,
        active: Product.where(active: true).count,
        out_of_stock: Product.where(stock: 0).count,
        low_stock: Product.where("stock <= ?", 5).count,
        items: Product
          .where(active: true)
          .order(stock: :asc)
          .limit(20)
          .map do |product|
            {
              id: product.id,
              name: product.name,
              price: product.price,
              stock: product.stock,
              average_rating: product.average_rating,
              reviews_count: product.reviews_count
            }
          end
      }
    end

    def orders
      {
        total: Order.count,
        pending: Order.pending.count,
        paid: Order.paid.count,
        processing: Order.processing.count,
        shipped: Order.shipped.count,
        delivered: Order.delivered.count,
        cancelled: Order.cancelled.count,
        total_revenue: Order.paid.sum(:total)
      }
    end

    def reviews
      {
        total: Review.count,
        approved: Review.approved.count,
        pending: Review.pending.count,
        rejected: Review.rejected.count
      }
    end

    def inventory
      InventoryMovement
        .includes(:product)
        .order(created_at: :desc)
        .limit(15)
        .map do |movement|
          {
            product: movement.product&.name,
            movement_type: movement.movement_type,
            quantity: movement.quantity,
            stock_before: movement.stock_before,
            stock_after: movement.stock_after,
            created_at: movement.created_at
          }
        end
    end

    def top_products
      Product
        .joins(:order_items)
        .select(
          "products.id,
           products.name,
           SUM(order_items.quantity) AS sold_quantity"
        )
        .group("products.id, products.name")
        .order("sold_quantity DESC")
        .limit(10)
        .map do |product|
          {
            id: product.id,
            name: product.name,
            sold_quantity: product.sold_quantity.to_i
          }
        end
    end
  end
end