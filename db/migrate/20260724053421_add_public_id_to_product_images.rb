class AddPublicIdToProductImages < ActiveRecord::Migration[8.1]
  def change
    add_column :product_images, :public_id, :string
  end
end
