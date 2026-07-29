class RefreshToken < ApplicationRecord
  belongs_to :user

  before_validation :normalize_token

  validates :token,
            presence: true,
            uniqueness: true

  validates :expires_at,
            presence: true

  scope :active, -> {
    where(revoked: false)
      .where("expires_at > ?", Time.current)
  }

  def revoke!
    update!(revoked: true)
  end

  def active?
    !revoked? && expires_at.future?
  end

  def expired?
    expires_at.past?
  end

  private

  def normalize_token
    self.token = token.to_s.strip
  end
end