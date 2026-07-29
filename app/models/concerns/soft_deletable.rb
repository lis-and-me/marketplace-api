module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :available, -> { where(deleted_at: nil) }
  end

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end
end