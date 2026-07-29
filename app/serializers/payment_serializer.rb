class PaymentSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :provider,
    :provider_payment_id,
    :amount,
    :currency,
    :status,
    :paid_at,
    :metadata,
    :created_at,
    :updated_at

  belongs_to :order
end