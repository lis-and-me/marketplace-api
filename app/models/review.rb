class Review < ApplicationRecord
  belongs_to :user,
             inverse_of: :reviews

  belongs_to :product,
             inverse_of: :reviews

  belongs_to :rating

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  validates :comment,
            presence: true,
            length: { maximum: 1000 }

  validates :user_id,
            uniqueness: {
              scope: :product_id
            }

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :rejected, -> { where(status: :rejected) }
end