class CreateProductImages < ActiveRecord::Migration[8.1]
  def change
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
t.string :image_url, null: false
t.integer :position, null: false, default: 1

      t.timestamps
    end
  end
end
