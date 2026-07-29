class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :coupon, optional: true

  has_many :order_items, dependent: :restrict_with_exception
  has_many :products, through: :order_items
  has_one :payment,
        dependent: :destroy

        has_many :inventory_movements,
         dependent: :nullify

  enum :status, {
    pending: 0,
    paid: 1,
    processing: 2,
    shipped: 3,
    delivered: 4,
    cancelled: 5
  }

  before_validation :calculate_total

  validates :subtotal,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :shipping,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :tax,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :discount,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :total,
            numericality: {
              greater_than_or_equal_to: 0
            }

  scope :recent, -> { order(created_at: :desc) }
  scope :pending, -> { where(status: :pending) }
  scope :paid, -> { where(status: :paid) }

  def recalculate_totals!
    self.subtotal = order_items.sum(&:subtotal)
    save!
  end

  private

  def calculate_total
    self.total = subtotal + shipping + tax - discount
  end
end