class UsersQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(scope = User.available, params = {})
    @scope = scope
    @params = params
  end

  def call
    users = @scope

    users = filter_by_search(users)
    users = filter_by_role(users)
    users = filter_by_status(users)

    users
      .order(created_at: :desc)
      .offset(offset)
      .limit(per_page)
  end

  def total_count
    users = @scope

    users = filter_by_search(users)
    users = filter_by_role(users)
    users = filter_by_status(users)

    users.count
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

  def filter_by_search(users)
    return users if @params[:search].blank?

    term = "%#{ActiveRecord::Base.sanitize_sql_like(@params[:search])}%"

    users.where(
      "name ILIKE :term
       OR last_name ILIKE :term
       OR email ILIKE :term",
      term: term
    )
  end

  def filter_by_role(users)
    return users if @params[:role].blank?

    users.where(role: @params[:role])
  end

  def filter_by_status(users)
    return users if @params[:status].blank?

    users.where(status: @params[:status])
  end

  def offset
    (page - 1) * per_page
  end
end