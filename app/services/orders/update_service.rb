module Orders
  class UpdateService
    def self.call(order:, params:)
      ActiveRecord::Base.transaction do
        order.update!(params)
        order
      end
    end
  end
end