module Payments
  class CreateService
    def self.call(
      order:,
      provider: :manual,
      payment_method: :oxxo
    )
      new(
        order: order,
        provider: provider,
        payment_method: payment_method
      ).call
    end

    def initialize(
      order:,
      provider:,
      payment_method:
    )
      @order = order
      @provider = provider
      @payment_method = payment_method
    end

    def call
      Payment.create!(
        order: @order,
        provider: @provider,
        payment_method: @payment_method,
        amount: @order.total,
        currency: "MXN",
        status: :pending
      )
    end
  end
end