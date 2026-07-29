class Brand < ApplicationRecord
  has_many :products,
         dependent: :restrict_with_exception,
         inverse_of: :brand

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 100 }

  before_validation :normalize_name

  scope :active, -> { where(active: true) }

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end