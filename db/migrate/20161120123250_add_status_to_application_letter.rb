class AddStatusToApplicationLetter < ActiveRecord::Migration
  def change
    add_column :application_letters, :status, :boolean
  end
end
