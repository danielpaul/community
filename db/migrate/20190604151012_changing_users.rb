class ChangingUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ty, :boolean
    remove_column :users, :school_year
  end
end
