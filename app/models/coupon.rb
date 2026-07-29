class Coupon < ApplicationRecord
  has_many :orders,
           dependent: :nullify

  enum :discount_type, {
    percentage: 0,
    fixed: 1
  }

  before_validation :normalize_code

  validates :code,
            presence: true,
            uniqueness: {
              case_sensitive: false
            }

  validates :value,
            presence: true,
            numericality: {
              greater_than: 0
            }

  validates :value,
            numericality: {
              less_than_or_equal_to: 100
            },
            if: :percentage?

  validates :minimum_amount,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :used_count,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :usage_limit,
            numericality: {
              only_integer: true,
              greater_than: 0
            },
            allow_nil: true

  validate :expiration_after_start

  def active_now?
    return false unless active?
    return false if starts_at.present? && starts_at > Time.current
    return false if expires_at.present? && expires_at < Time.current

    return false if usage_limit.present? &&
                    used_count >= usage_limit

    true
  end

  def discount_for(subtotal)
    return 0 if subtotal < minimum_amount

    if percentage?
      (subtotal * value / 100).round(2)
    else
      [value, subtotal].min
    end
  end

  private

  def normalize_code
    self.code = code.to_s.upcase.strip
  end

  def expiration_after_start
    return if starts_at.blank? || expires_at.blank?
    return if expires_at > starts_at

    errors.add(
      :expires_at,
      "must be after the start date"
    )
  end
end