class ProductsQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(scope = Product.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    products = @scope

    products = filter_by_search(products)
    products = filter_by_brand(products)
    products = filter_by_category(products)
    products = filter_by_active(products)

    products
      .distinct
      .order(created_at: :desc)
      .offset(offset)
      .limit(per_page)
  end

  def total_count
    products = @scope

    products = filter_by_search(products)
    products = filter_by_brand(products)
    products = filter_by_category(products)
    products = filter_by_active(products)

    products.distinct.count
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

  def filter_by_search(products)
    return products if @params[:search].blank?

    term = "%#{ActiveRecord::Base.sanitize_sql_like(@params[:search])}%"

    products.where(
      "products.name ILIKE :term OR products.sku ILIKE :term OR products.slug ILIKE :term",
      term: term
    )
  end

  def filter_by_brand(products)
    return products if @params[:brand_id].blank?

    products.where(brand_id: @params[:brand_id])
  end

  def filter_by_category(products)
    return products if @params[:category_id].blank?

    products
      .joins(:product_categories)
      .where(product_categories: { category_id: @params[:category_id] })
  end

  def filter_by_active(products)
    return products unless @params[:active].to_s.in?(%w[true false])

    products.where(active: ActiveModel::Type::Boolean.new.cast(@params[:active]))
  end

  def offset
    (page - 1) * per_page
  end
end