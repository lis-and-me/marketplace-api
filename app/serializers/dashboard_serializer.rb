class DashboardSerializer
  def initialize(data)
    @data = data
  end

  def as_json(*)
    {
      users: @data[:users],
      products: @data[:products],
      orders: @data[:orders],
      revenue: @data[:revenue],
      reviews: @data[:reviews],
      coupons: @data[:coupons],

      sales_by_month: @data[:sales_by_month],
      sales_last_30_days: @data[:sales_last_30_days],
      orders_by_status: @data[:orders_by_status],
      new_users_by_month: @data[:new_users_by_month],

      top_products: top_products,
      latest_orders: latest_orders,
      top_customers: top_customers,
      low_stock_products: low_stock_products,
      latest_inventory_movements: latest_inventory_movements
    }
  end

  private

  def top_products
    @data[:top_products].map do |product|
      {
        id: product.id,
        name: product.name,
        sold_quantity: product.sold_quantity.to_i
      }
    end
  end

  def latest_orders
    @data[:latest_orders].map do |order|
      {
        id: order.id,
        customer: order.user&.then do |user|
          "#{user.name} #{user.last_name}"
        end,
        status: order.status,
        total: order.total,
        created_at: order.created_at
      }
    end
  end

  def top_customers
    @data[:top_customers].map do |user|
      {
        id: user.id,
        name: "#{user.name} #{user.last_name}",
        orders_count: user.orders_count.to_i,
        total_spent: user.total_spent.to_f
      }
    end
  end

  def low_stock_products
    @data[:low_stock_products].map do |product|
      {
        id: product.id,
        name: product.name,
        stock: product.stock
      }
    end
  end

  def latest_inventory_movements
    @data[:latest_inventory_movements].map do |movement|
      {
        id: movement.id,
        product: movement.product&.name,
        movement_type: movement.movement_type,
        quantity: movement.quantity,
        stock_before: movement.stock_before,
        stock_after: movement.stock_after,
        created_at: movement.created_at
      }
    end
  end
end