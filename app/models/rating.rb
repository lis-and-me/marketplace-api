class Rating < ApplicationRecord
  belongs_to :user,
             inverse_of: :ratings

  belongs_to :product,
             inverse_of: :ratings

  has_one :review,
          dependent: :destroy,
          inverse_of: :rating

  validates :score,
            inclusion: { in: 1..5 }

  validates :user_id,
            uniqueness: {
              scope: :product_id
            }
end