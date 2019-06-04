class CreateUsername < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :display_name, :username
  end
end
