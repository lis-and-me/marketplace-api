module Filters
  class SortingService
    DEFAULT_DIRECTION = "desc"

    def self.call(scope, params, allowed_columns)
      sort = params[:sort].to_s
      direction = params[:direction].to_s.downcase

      return scope unless allowed_columns.include?(sort)

      direction = %w[asc desc].include?(direction) ? direction : DEFAULT_DIRECTION

      scope.order(sort => direction)
    end
  end
end