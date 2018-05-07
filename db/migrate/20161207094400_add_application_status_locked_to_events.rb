class AddApplicationStatusLockedToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :application_status_locked, :boolean
  end
end
