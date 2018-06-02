class AddStatusToApplicationLetter < ActiveRecord::Migration[4.2]
  def change
    add_column :application_letters, :status, :boolean
  end
end
