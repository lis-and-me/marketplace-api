class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
    t.text :comment, null: false
t.integer :status, null: false, default: 0


      t.timestamps
    end
    add_index :reviews,
[:user_id, :product_id],
unique: true
  end
end
