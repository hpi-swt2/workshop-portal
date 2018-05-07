class ChangeWorkshopToEvent < ActiveRecord::Migration[4.2]
  def change
    rename_table :workshops, :events
    rename_column :application_letters, :workshop_id, :event_id
  end
end
