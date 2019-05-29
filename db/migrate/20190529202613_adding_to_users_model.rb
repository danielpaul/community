class AddingToUsersModel < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_name, :string
    add_column :users, :allow_marketing, :boolean
    add_column :users, :user_type, :integer
    add_column :users, :year_of_graduation, :integer
  end
end
