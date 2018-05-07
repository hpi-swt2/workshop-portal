class RenameVegeterianToVegetarian < ActiveRecord::Migration[4.2]
  def change
    rename_column :application_letters, :vegeterian, :vegetarian
  end
end
