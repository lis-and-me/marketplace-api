require "securerandom"
class Product < ApplicationRecord
  include SoftDeletable
  belongs_to :brand,
           inverse_of: :products

  has_many :product_images,
         dependent: :destroy,
         inverse_of: :product
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  has_many :reviews,
         dependent: :destroy,
         inverse_of: :product

  has_many :cart_items, dependent: :restrict_with_exception
  has_many :order_items, dependent: :restrict_with_exception


has_many :ratings,
         dependent: :destroy,
         inverse_of: :product

         has_many :wishlist_items,
         dependent: :destroy

has_many :wishlisted_by,
         through: :wishlist_items,
         source: :user

         has_many :inventory_movements,
         dependent: :destroy

  before_validation :normalize_fields

  validates :name,
            presence: true,
            length: { maximum: 255 }

validates :slug,
          uniqueness: { case_sensitive: false }

  validates :sku,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 100 }

  validates :description,
            presence: true

  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :stock,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  scope :active, -> { where(active: true) }
  scope :available, -> { where(deleted_at: nil) }
  scope :in_stock, -> { where("stock > 0") }

  private

  def normalize_fields
  self.name = name.to_s.strip
  self.sku = sku.to_s.strip.upcase

  generate_slug if slug.blank?
end

def generate_slug
  base_slug = name.parameterize
  slug_candidate = base_slug

  while Product.exists?(slug: slug_candidate)
    slug_candidate = "#{base_slug}-#{SecureRandom.hex(3)}"
  end

  self.slug = slug_candidate
end
end