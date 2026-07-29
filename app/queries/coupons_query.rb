class CouponsQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(scope = Coupon.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    coupons = @scope

    coupons = filter_by_search(coupons)
    coupons = filter_by_active(coupons)
    coupons = filter_by_discount_type(coupons)

    coupons
      .order(created_at: :desc)
      .offset(offset)
      .limit(per_page)
  end

  def total_count
    coupons = @scope

    coupons = filter_by_search(coupons)
    coupons = filter_by_active(coupons)
    coupons = filter_by_discount_type(coupons)

    coupons.count
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

  def filter_by_search(coupons)
    return coupons if @params[:search].blank?

    term = "%#{ActiveRecord::Base.sanitize_sql_like(@params[:search])}%"

    coupons.where("code ILIKE ?", term)
  end

  def filter_by_active(coupons)
    return coupons unless @params[:active].to_s.in?(%w[true false])

    coupons.where(
      active: ActiveModel::Type::Boolean.new.cast(@params[:active])
    )
  end

  def filter_by_discount_type(coupons)
    return coupons if @params[:discount_type].blank?

    coupons.where(discount_type: @params[:discount_type])
  end

  def offset
    (page - 1) * per_page
  end
end