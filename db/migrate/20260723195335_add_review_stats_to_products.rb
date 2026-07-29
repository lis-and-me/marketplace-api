class AddReviewStatsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products,
               :average_rating,
               :decimal,
               precision: 3,
               scale: 2,
               default: 0,
               null: false

    add_column :products,
               :reviews_count,
               :integer,
               default: 0,
               null: false
  end
end