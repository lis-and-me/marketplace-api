class OrdersQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(scope = Order.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    orders = @scope

    orders = filter_by_status(orders)
    orders = filter_by_user(orders)

    orders
      .includes(:user, :address, order_items: :product)
      .order(created_at: :desc)
      .offset(offset)
      .limit(per_page)
  end

  def total_count
    orders = @scope

    orders = filter_by_status(orders)
    orders = filter_by_user(orders)

    orders.count
  end

  def page
    value = @params[:page].to_i
    value.positive? ? value : DEFAULT_PAGE
  end

  def per_page
    value = @params[:per_page].to_i
    value = DEFAULT_PER_PAGE unless value.positive?

    [value, MAX_PER_PAGE].min
  end

  private

  def filter_by_status(orders)
    return orders if @params[:status].blank?

    orders.where(status: @params[:status])
  end

  def filter_by_user(orders)
    return orders if @params[:user_id].blank?

    orders.where(user_id: @params[:user_id])
  end

  def offset
    (page - 1) * per_page
  end
end