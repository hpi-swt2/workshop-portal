class AddGroupToApplicationLetter < ActiveRecord::Migration
  def change
    add_column :application_letters, :group, :integer
  end
end
