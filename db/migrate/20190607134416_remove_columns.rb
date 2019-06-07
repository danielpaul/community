class RemoveColumns < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :users, :username }
  end
end
