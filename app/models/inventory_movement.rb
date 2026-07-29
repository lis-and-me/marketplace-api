class InventoryMovement < ApplicationRecord
  belongs_to :product
  belongs_to :order, optional: true

  enum :movement_type, {
    purchase: 0,
    adjustment: 1,
    return: 2,
    restock: 3,
    cancellation: 4
  }

  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              other_than: 0
            }

  validates :stock_before,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :stock_after,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end