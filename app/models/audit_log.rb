class AuditLog < ApplicationRecord
  belongs_to :user

  validates :action,
            presence: true,
            length: { maximum: 100 }

  validates :table_name,
            presence: true,
            length: { maximum: 100 }

  validates :record_id,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  validates :ip_address,
            length: { maximum: 45 },
            allow_blank: true

  scope :recent, -> { order(created_at: :desc) }
end