class CreateRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :score, null: false

      t.timestamps
    end
         add_index :ratings,
[:user_id, :product_id],
unique: true

add_check_constraint :ratings,
                     "score >= 1 AND score <= 5",
                     name: "ratings_score_check"
  end
end
