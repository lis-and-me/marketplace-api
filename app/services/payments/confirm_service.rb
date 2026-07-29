module Payments
  class ConfirmService
    def self.call(payment:, provider_payment_id:)
      new(payment:, provider_payment_id:).call
    end

    def initialize(payment:, provider_payment_id:)
      @payment = payment
      @provider_payment_id = provider_payment_id
    end

    def call
      ActiveRecord::Base.transaction do
        @payment.update!(
          provider_payment_id: @provider_payment_id,
          status: :paid,
          paid_at: Time.current
        )

        @payment.order.update!(
          status: :paid
        )

        @payment
      end
    end
  end
end