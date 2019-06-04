class AddingSchoolYear < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :school_year, :integer
  end
end
