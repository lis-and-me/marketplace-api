class ProductSerializer < ActiveModel::Serializer
attributes :id,
           :name,
           :slug,
           :sku,
           :description,
           :price,
           :stock,
           :active,
           :average_rating,
           :reviews_count,
           :deleted_at,
           :created_at,
           :updated_at,
           :can_review

  belongs_to :brand

  has_many :categories
  has_many :product_images

  def average_rating
    object.average_rating.to_f.round(1)
  end

 def reviews_count
  object.reviews.approved.count
end

def can_review
  instance_options[:can_review]
end
end