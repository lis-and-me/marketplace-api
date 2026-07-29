module Dashboard
  class StatsService
    def self.call
      new.call
    end

    def call
      {
        users: users,
        products: products,
        orders: orders,
        revenue: revenue,
        reviews: reviews,
        coupons: coupons,
        top_products: top_products,
        latest_orders: latest_orders,
        top_customers: top_customers,
        low_stock_products: low_stock_products,
        latest_inventory_movements: latest_inventory_movements,
        sales_by_month: sales_by_month,
sales_last_30_days: sales_last_30_days,
orders_by_status: orders_by_status,
new_users_by_month: new_users_by_month
      }
    end

    private

    def users
      {
        total: User.count,
        admins: User.admin.count,
        users: User.user.count,
        active: User.active.count
      }
    end

    def products
      {
        total: Product.count,
        active: Product.where(active: true).count,
        out_of_stock: Product.where(stock: 0).count,
        low_stock: Product.where("stock <= ?", 5).count
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
        cancelled: Order.cancelled.count
      }
    end

   def revenue
  {
    total: revenue_orders.sum(:total),

    today: revenue_orders
      .where(created_at: Time.zone.today.all_day)
      .sum(:total),

    month: revenue_orders
      .where(created_at: Time.current.all_month)
      .sum(:total)
  }
end

    def reviews
      {
        total: Review.count,
        pending: Review.pending.count,
        approved: Review.approved.count,
        rejected: Review.rejected.count
      }
    end

    def coupons
      {
        total: Coupon.count,
        active: Coupon.where(active: true).count
      }
    end

   def top_products
  Product
    .joins(order_items: :order)
    .where.not(
      orders: {
        status: Order.statuses[:cancelled]
      }
    )
    .select(
      "products.id,
       products.name,
       SUM(order_items.quantity) AS sold_quantity"
    )
    .group(
      "products.id,
       products.name"
    )
    .order("sold_quantity DESC")
    .limit(5)
end

    def latest_orders
      Order
        .includes(:user)
        .recent
        .limit(10)
    end

  def top_customers
  User
    .joins(:orders)
    .where.not(
      orders: {
        status: Order.statuses[:cancelled]
      }
    )
    .select(
      "users.id,
       users.name,
       users.last_name,
       COUNT(orders.id) AS orders_count,
       COALESCE(SUM(orders.total), 0) AS total_spent"
    )
    .group(
      "users.id,
       users.name,
       users.last_name"
    )
    .order("total_spent DESC")
    .limit(5)
end
    def low_stock_products
      Product
        .where("stock <= ?", 5)
        .order(:stock)
        .limit(10)
    end

    def latest_inventory_movements
      InventoryMovement
        .includes(:product, :order)
        .order(created_at: :desc)
        .limit(10)
    end
 def sales_by_month
  revenue_orders
    .group_by_month(
      :created_at,
      last: 12,
      format: "%b"
    )
    .sum(:total)
end

def sales_last_30_days
  revenue_orders
    .group_by_day(
      :created_at,
      last: 30,
      format: "%d %b"
    )
    .sum(:total)
end
def orders_by_status
  Order.group(:status).count
end

def revenue_orders
  Order.where(
    status: %i[
      paid
      processing
      shipped
      delivered
    ]
  )
end
def new_users_by_month
  User
    .group_by_month(:created_at, last: 12, format: "%b")
    .count
end
  end
end