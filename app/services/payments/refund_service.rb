module Payments
  class RefundService
    def self.call(payment:)
      new(payment:).call
    end

    def initialize(payment:)
      @payment = payment
    end

    def call
      ActiveRecord::Base.transaction do
        @payment.update!(
          status: :refunded
        )

        @payment.order.update!(
          status: :cancelled
        )

        @payment
      end
    end
  end
end