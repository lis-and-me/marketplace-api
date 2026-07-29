class Payment < ApplicationRecord
  belongs_to :order
  enum :payment_method, {
  oxxo: 0,
  card: 1
}

  enum :provider, {
    stripe: 0,
    mercadopago: 1,
    paypal: 2,
    manual: 3
  }

  enum :status, {
    pending: 0,
    processing: 1,
    paid: 2,
    failed: 3,
    refunded: 4,
    cancelled: 5
  }

  validates :amount,
            numericality: {
              greater_than: 0
            }

  validates :currency,
            presence: true

  validates :provider_payment_id,
            uniqueness: true,
            allow_nil: true
end