class Cart < ApplicationRecord
  belongs_to :user

  has_many :cart_items,
         dependent: :destroy,
         inverse_of: :cart

  has_many :products, through: :cart_items
  
end