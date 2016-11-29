class AddOrganizerToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :organizer, :string
  end
end
