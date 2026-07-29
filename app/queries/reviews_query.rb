class ReviewsQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(scope = Review.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    reviews = @scope

    reviews = filter_by_search(reviews)
    reviews = filter_by_status(reviews)
    reviews = filter_by_product(reviews)
    reviews = filter_by_user(reviews)

    reviews
      .includes(:user, :product, :rating)
      .order(created_at: :desc)
      .offset(offset)
      .limit(per_page)
  end

  def total_count
    reviews = @scope

    reviews = filter_by_search(reviews)
    reviews = filter_by_status(reviews)
    reviews = filter_by_product(reviews)
    reviews = filter_by_user(reviews)

    reviews.count
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

  def filter_by_search(reviews)
    return reviews if @params[:search].blank?

    term = "%#{ActiveRecord::Base.sanitize_sql_like(@params[:search])}%"

    reviews
      .joins(:user, :product)
      .where(
        "users.name ILIKE :term
         OR users.last_name ILIKE :term
         OR users.email ILIKE :term
         OR products.name ILIKE :term
         OR reviews.comment ILIKE :term",
        term: term
      )
  end

  def filter_by_status(reviews)
    return reviews if @params[:status].blank?

    reviews.where(status: @params[:status])
  end

  def filter_by_product(reviews)
    return reviews if @params[:product_id].blank?

    reviews.where(product_id: @params[:product_id])
  end

  def filter_by_user(reviews)
    return reviews if @params[:user_id].blank?

    reviews.where(user_id: @params[:user_id])
  end

  def offset
    (page - 1) * per_page
  end
end