class CreateCategoriesModel < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.references :categories, index: true
    end
  end
end
