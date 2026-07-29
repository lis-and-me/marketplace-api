class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :last_name,
             :email,
             :phone,
             :role,
             :status,
             :suspended_until,
             :last_login_at,
             :created_at,
             :updated_at
end