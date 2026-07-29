class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
    t.string :action, null: false
t.string :table_name, null: false
t.bigint :record_id, null: false
t.jsonb :old_values, default: {}
t.jsonb :new_values, default: {}
t.string :ip_address

      t.timestamps
    end
  end
end
