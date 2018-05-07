class RemoveAllergicFromApplicationLetter < ActiveRecord::Migration[4.2]
  def change
    remove_column :application_letters, :allergic
  end
end
