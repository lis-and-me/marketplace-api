class ReviewSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :comment,
    :status,
    :score,
    :user_name,
    :user_email,
    :product_id,
    :product_name,
    :created_at,
    :is_owner
  )

  def score
    object.rating&.score
  end

  def user_name
    return unless object.user

    [
      object.user.name,
      object.user.last_name
    ].compact.join(" ")
  end

  def user_email
    object.user&.email
  end

  def product_name
    object.product&.name
  end
def is_owner
  scope.present? &&
    scope.id == object.user_id
end
end