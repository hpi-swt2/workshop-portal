class AddOrganizerToWorkshops < ActiveRecord::Migration
  def self.up
    add_column :events, :organizer, :string unless column_exists?(:events, :organizer)
  end

  def self.down
    Profile.reset_column_information
    remove_column :events, :organizer, :string if column_exists?(:events, :organizer)
  end
end
