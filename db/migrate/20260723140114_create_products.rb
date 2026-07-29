class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :brand, null: false, foreign_key: true

      t.string :name, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.string :sku, null: false

      t.decimal :price,
                precision: 10,
                scale: 2,
                null: false

      t.integer :stock,
                null: false,
                default: 0

      t.boolean :active,
                null: false,
                default: true

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
    add_index :products, :deleted_at

    add_check_constraint :products,
                         "price >= 0",
                         name: "products_price_check"

    add_check_constraint :products,
                         "stock >= 0",
                         name: "products_stock_check"
  end
end