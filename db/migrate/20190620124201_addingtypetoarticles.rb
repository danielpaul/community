class Addingtypetoarticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :type, :integer, default: 0, null: false
  end
end
