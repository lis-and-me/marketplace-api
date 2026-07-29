class CartItemSerializer < ActiveModel::Serializer
  attributes :id,
             :quantity,
             :unit_price,
             :subtotal,
             :created_at,
             :updated_at,
             :product

def product
  {
    id: object.product.id,
    name: object.product.name,
    slug: object.product.slug,
    sku: object.product.sku,
    description: object.product.description,
    price: object.product.price,
    stock: object.product.stock,
    active: object.product.active,

    product_images: object.product.product_images
      .order(:position)
      .map do |image|
        {
          id: image.id,
          image_url: image.image_url,
          position: image.position
        }
      end
  }
end
end