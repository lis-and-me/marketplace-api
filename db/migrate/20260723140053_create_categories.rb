class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.references :parent,
             null: true,
             foreign_key: {
               to_table: :categories,
               on_delete: :nullify
             }
      t.boolean :active, null: false, default: true


      t.timestamps
    end
       add_index :categories, :name, unique: true
  end
end
