class Address < ApplicationRecord
  belongs_to :user,
           inverse_of: :addresses
  validates :alias,
            presence: true,
            length: { maximum: 100 }

  validates :recipient,
            presence: true,
            length: { maximum: 150 }

  validates :street,
            presence: true,
            length: { maximum: 255 }

  validates :external_number,
            presence: true,
            length: { maximum: 20 }

  validates :internal_number,
            length: { maximum: 20 },
            allow_blank: true

  validates :neighborhood,
            presence: true,
            length: { maximum: 100 }

  validates :city,
            presence: true,
            length: { maximum: 100 }

  validates :state,
            presence: true,
            length: { maximum: 100 }

  validates :postal_code,
            presence: true,
            length: { maximum: 20 }

  validates :country,
            presence: true,
            length: { maximum: 100 }

  validates :references,
            length: { maximum: 500 },
            allow_blank: true
end