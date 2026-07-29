class AddRatingToReviews < ActiveRecord::Migration[8.1]
  def change
    add_reference :reviews, :rating, null: false, foreign_key: true
  end
end
