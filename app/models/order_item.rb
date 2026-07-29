class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_validation :set_product_snapshot, on: :create
  before_validation :calculate_subtotal

  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  validates :unit_price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :subtotal,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :product_name,
            presence: true

  validates :product_sku,
            presence: true

  private

  def set_product_snapshot
    return if product.blank?

    self.product_name ||= product.name
    self.product_sku ||= product.sku
  end

  def calculate_subtotal
    return if quantity.blank? || unit_price.blank?

    self.subtotal = quantity * unit_price
  end
end