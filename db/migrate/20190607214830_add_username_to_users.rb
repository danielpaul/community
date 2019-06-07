class AddUsernameToUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true, algorithm: :concurrently
  end
end
