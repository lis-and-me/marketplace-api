class OrderItemSerializer < ActiveModel::Serializer
  attributes :id,
             :product_id,
             :product_name,
             :product_sku,
             :quantity,
             :unit_price,
             :subtotal,
             :image_url

  belongs_to :product

  def product_id
    object.product_id
  end

  def image_url
    object.product.product_images
          .order(:position)
          .first
          &.image_url
  end
end