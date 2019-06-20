class AddingToArticles < ActiveRecord::Migration[6.0]
  def change

    add_reference :articles, :approved_by, foreign_key: {to_table: :users}
    add_column :articles, :url, :string
    add_column :articles, :approved_at, :timestamp

  end
end
