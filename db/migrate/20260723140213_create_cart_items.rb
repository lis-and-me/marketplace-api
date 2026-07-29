class CreateCartItems < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
     t.integer :quantity,
null: false,
default: 1

t.decimal :unit_price,
precision: 10,
scale: 2,
null: false


      t.timestamps
    end
    add_index :cart_items,
[:cart_id, :product_id],
unique: true



add_check_constraint :cart_items,
                     "quantity > 0",
                     name: "cart_items_quantity_check"

add_check_constraint :cart_items,
                     "unit_price >= 0",
                     name: "cart_items_price_check"
  end
end
