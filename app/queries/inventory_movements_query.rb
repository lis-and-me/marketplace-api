class InventoryMovementsQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(scope = InventoryMovement.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    movements = @scope

    movements = filter_by_product(movements)
    movements = filter_by_order(movements)
    movements = filter_by_type(movements)

    movements
      .includes(:product, :order)
      .order(created_at: :desc)
      .offset(offset)
      .limit(per_page)
  end

  def total_count
    movements = @scope

    movements = filter_by_product(movements)
    movements = filter_by_order(movements)
    movements = filter_by_type(movements)

    movements.count
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

  def filter_by_product(movements)
    return movements if @params[:product_id].blank?

    movements.where(product_id: @params[:product_id])
  end

  def filter_by_order(movements)
    return movements if @params[:order_id].blank?

    movements.where(order_id: @params[:order_id])
  end

  def filter_by_type(movements)
    return movements if @params[:movement_type].blank?

    movements.where(movement_type: @params[:movement_type])
  end

  def offset
    (page - 1) * per_page
  end
end