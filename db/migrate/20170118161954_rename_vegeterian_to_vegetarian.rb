class RenameVegeterianToVegetarian < ActiveRecord::Migration
  def change
    rename_column :application_letters, :vegeterian, :vegetarian
  end
end
