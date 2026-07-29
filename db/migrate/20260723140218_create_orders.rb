class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.integer :status,
null: false,
default: 0
      t.decimal :subtotal, precision: 10,
scale: 2,
null: false,
default: 0
      t.decimal :shipping, precision: 10,
scale: 2,
null: false,
default: 0
      t.decimal :tax, precision: 10,
scale: 2,
null: false,
default: 0
      t.decimal :discount, precision: 10,
scale: 2,
null: false,
default: 0
      t.decimal :total, precision: 10,
scale: 2,
null: false,
default: 0

      t.timestamps
    end

    add_check_constraint :orders,
                     "subtotal >= 0",
                     name: "orders_subtotal_check"

add_check_constraint :orders,
                     "shipping >= 0",
                     name: "orders_shipping_check"

add_check_constraint :orders,
                     "tax >= 0",
                     name: "orders_tax_check"

add_check_constraint :orders,
                     "discount >= 0",
                     name: "orders_discount_check"

add_check_constraint :orders,
                     "total >= 0",
                     name: "orders_total_check"
  end
end
