class RenameApplicationsToApplicationLetters < ActiveRecord::Migration
  def change
    rename_table :applications, :application_letters
  end
end
