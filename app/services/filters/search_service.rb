module Filters
  class SearchService
    def self.call(scope, search, columns)
      return scope if search.blank?

      query = "%#{search.strip.downcase}%"

      conditions = columns.map do |column|
        "LOWER(CAST(#{column} AS TEXT)) LIKE :query"
      end.join(" OR ")

      scope.where(conditions, query: query)
    end
  end
end