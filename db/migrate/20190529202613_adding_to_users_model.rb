class AddingToUsersModel < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :allow_marketing, :boolean, default: false
    add_column :users, :user_type, :integer, default: 0
    add_column :users, :year_of_graduation, :integer, allow_nil: true, allow_blank: false
  end
end
