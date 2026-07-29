class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
t.string :last_name, null: false
t.string :email, null: false
t.string :password_digest, null: false
t.string :phone

t.integer :role, null: false, default: 0
t.integer :status, null: false, default: 0

t.datetime :email_verified_at
t.datetime :last_login_at
t.datetime :deleted_at


      t.timestamps
    end
    add_index :users, :email, unique: true
add_index :users, :deleted_at
  end
end
