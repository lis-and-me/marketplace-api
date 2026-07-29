module Filters
  class PaginationService
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 20
    MAX_PER_PAGE = 100

    def self.call(scope, params)
      page = params[:page].to_i
      per_page = params[:per_page].to_i

      page = DEFAULT_PAGE if page <= 0
      per_page = DEFAULT_PER_PAGE if per_page <= 0
      per_page = MAX_PER_PAGE if per_page > MAX_PER_PAGE

      scope.offset((page - 1) * per_page)
           .limit(per_page)
    end
  end
end