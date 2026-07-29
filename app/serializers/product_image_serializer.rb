class ProductImageSerializer < ActiveModel::Serializer
  attributes :id,
             :image_url,
             :public_id,
             :position,
             :created_at,
             :updated_at
end