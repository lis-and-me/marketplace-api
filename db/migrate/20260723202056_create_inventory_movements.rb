class CreateInventoryMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_movements do |t|
      t.references :product,
                   null: false,
                   foreign_key: true

      t.references :order,
                   foreign_key: true

      t.integer :movement_type,
                null: false

      t.integer :quantity,
                null: false

      t.integer :stock_before,
                null: false

      t.integer :stock_after,
                null: false

      t.string :note

      t.timestamps
    end
  end
end