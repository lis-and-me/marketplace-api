class BrandSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :active,
             :created_at,
             :updated_at
end