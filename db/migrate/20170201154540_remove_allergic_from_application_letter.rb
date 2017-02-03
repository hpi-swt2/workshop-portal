class RemoveAllergicFromApplicationLetter < ActiveRecord::Migration
  def change
    remove_column :application_letters, :allergic
  end
end
