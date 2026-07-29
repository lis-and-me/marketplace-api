class WishlistItemSerializer < ActiveModel::Serializer
  attributes :id, :created_at

  belongs_to :product
end