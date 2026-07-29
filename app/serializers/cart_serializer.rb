class CartSerializer < ActiveModel::Serializer
  attributes :id,
             :total,
             :created_at,
             :updated_at

  has_many :cart_items

  def total
    object.cart_items.sum(&:subtotal)
  end
end