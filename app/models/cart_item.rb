class CartItem < ApplicationRecord
  belongs_to :cart, inverse_of: :cart_items
belongs_to :product, inverse_of: :cart_items

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

  validates :product_id,
            uniqueness: {
              scope: :cart_id
            }

  def subtotal
    quantity * unit_price
  end
end