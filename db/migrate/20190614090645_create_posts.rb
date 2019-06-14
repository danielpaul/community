class CreatePosts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    create_table :posts do |t|

      t.references :category, null: false
      t.references :user, null: false
      t.string :title, null: false
      t.integer  :status, default: 0, null: false
      t.integer  :visibility, default: 0, null: false
      t.timestamps
    end
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true, algorithm: :concurrently
  end
end
