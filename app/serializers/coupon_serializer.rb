class CouponSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :code,
    :discount_type,
    :value,
    :minimum_amount,
    :usage_limit,
    :used_count,
    :active,
    :starts_at,
    :expires_at,
    :created_at,
    :updated_at
end