class RemoveCVandEmailFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :cv, :string
    remove_column :profiles, :email, :string
  end
end
