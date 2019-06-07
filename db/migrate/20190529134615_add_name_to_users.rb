class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string, allow_blank: false, allow_nil: true
    add_column :users, :last_name, :string, allow_blank: false, allow_nil: true
  end
end
