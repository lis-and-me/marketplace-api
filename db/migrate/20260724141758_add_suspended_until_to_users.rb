class AddSuspendedUntilToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :suspended_until, :datetime
  end
end
