class AddSlugToCategories < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true, algorithm: :concurrently
  end
end
