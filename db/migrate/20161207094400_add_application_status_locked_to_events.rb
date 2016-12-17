class AddApplicationStatusLockedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :application_status_locked, :boolean
  end
end
