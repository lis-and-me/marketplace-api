class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
t.string :alias, null: false
t.string :recipient, null: false
t.string :street, null: false
t.string :external_number, null: false
t.string :internal_number
t.string :neighborhood, null: false
t.string :city, null: false
t.string :state, null: false
t.string :postal_code, null: false
t.string :country, null: false
t.text :references
t.boolean :is_default, default: false, null: false

      t.timestamps
    end
  end
end
