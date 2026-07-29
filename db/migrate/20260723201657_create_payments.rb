class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :order,
                   null: false,
                   foreign_key: true

      t.integer :provider,
                null: false

      t.string :provider_payment_id

      t.decimal :amount,
                precision: 10,
                scale: 2,
                null: false

      t.string :currency,
               default: "MXN",
               null: false

      t.integer :status,
                default: 0,
                null: false

      t.datetime :paid_at

      t.jsonb :metadata,
              default: {},
              null: false

      t.timestamps
    end

    add_index :payments,
              :provider_payment_id,
              unique: true
  end
end