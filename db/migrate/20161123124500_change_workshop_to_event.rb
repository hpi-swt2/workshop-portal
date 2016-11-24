class ChangeWorkshopToEvent < ActiveRecord::Migration
  def change
    rename_table :workshops, :events
    rename_column :application_letters, :workshop_id, :event_id
  end
end
