class AddressSerializer < ActiveModel::Serializer
  attributes :id,
             :alias,
             :recipient,
             :street,
             :external_number,
             :internal_number,
             :neighborhood,
             :city,
             :state,
             :postal_code,
             :country,
             :references,
             :is_default,
             :created_at,
             :updated_at
end