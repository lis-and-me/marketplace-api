class AddProductSnapshotToOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :product_name, :string
    add_column :order_items, :product_sku, :string
  end
end