class ChangingUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ty, :boolean, allow_nil: false, default: false
  end
end
