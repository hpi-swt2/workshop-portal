class RenameApplicationsToApplicationLetters < ActiveRecord::Migration[4.2]
  def change
    rename_table :applications, :application_letters
  end
end
