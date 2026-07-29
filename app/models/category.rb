class Category < ApplicationRecord
  belongs_to :parent,
             class_name: "Category",
             optional: true

  has_many :children,
           class_name: "Category",
           foreign_key: :parent_id,
           dependent: :nullify,
           inverse_of: :parent

  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 100 }

  validates :description,
            length: { maximum: 500 },
            allow_blank: true

  before_validation :normalize_name

  scope :active, -> { where(active: true) }
  scope :roots, -> { where(parent_id: nil) }

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end