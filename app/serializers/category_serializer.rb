class CategorySerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :parent_id,
             :active,
             :created_at,
             :updated_at
end 