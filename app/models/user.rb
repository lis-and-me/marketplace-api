class User < ApplicationRecord
  include SoftDeletable
  has_secure_password

  has_many :addresses,
         dependent: :destroy,
         inverse_of: :user
  has_one :cart, dependent: :destroy

  has_many :orders, dependent: :restrict_with_exception
  
  
  has_many :refresh_tokens, dependent: :destroy
  has_many :audit_logs, dependent: :restrict_with_exception
  has_many :reviews,
         dependent: :destroy,
         inverse_of: :user

has_many :ratings,
         dependent: :destroy,
         inverse_of: :user

         has_many :wishlist_items,
         dependent: :destroy

has_many :wishlist_products,
         through: :wishlist_items,
         source: :product
  enum :status, {
  pending_verification: 0,
  active: 1,
  suspended: 2,
  deleted: 3
}
  enum :role, {
  user: 0,
  admin: 1,
}

  before_validation :normalize_email

  validates :name,
            presence: true,
            length: { maximum: 100 }

  validates :last_name,
            presence: true,
            length: { maximum: 100 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone,
            length: { maximum: 20 },
            allow_blank: true

  validates :password,
            length: { minimum: 8 },
            allow_nil: true

  scope :active, -> { where(status: :active) }

  def suspended_indefinitely?
  suspended? && suspended_until.nil?
end

def temporary_suspension?
  suspended? && suspended_until.present?
end

def suspension_expired?
  temporary_suspension? &&
    suspended_until <= Time.current
end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end