class RemoveCVandEmailFromProfile < ActiveRecord::Migration[4.2]
  def change
    remove_column :profiles, :cv, :string
    remove_column :profiles, :email, :string
  end
end
