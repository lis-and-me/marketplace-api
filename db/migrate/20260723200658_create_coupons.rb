class CreateCoupons < ActiveRecord::Migration[8.1]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.integer :discount_type, null: false

      t.decimal :value,
                precision: 10,
                scale: 2,
                null: false

      t.decimal :minimum_amount,
                precision: 10,
                scale: 2,
                default: 0,
                null: false

      t.integer :usage_limit
      t.integer :used_count,
                default: 0,
                null: false

      t.boolean :active,
                default: true,
                null: false

      t.datetime :starts_at
      t.datetime :expires_at

      t.timestamps
    end

    add_index :coupons,
              :code,
              unique: true
  end
end