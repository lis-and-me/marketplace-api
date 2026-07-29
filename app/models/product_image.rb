class ProductImage < ApplicationRecord
  belongs_to :product,
             inverse_of: :product_images

  before_validation :normalize_fields

  validates :image_url,
            presence: true,
            length: { maximum: 500 }

  validates :public_id,
            presence: true,
            length: { maximum: 255 }

  validates :position,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  private

  def normalize_fields
    self.image_url = image_url.to_s.strip
    self.public_id = public_id.to_s.strip
  end
end