class RemoveApplicationStatusLockedFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :application_status_locked, :boolean
  end
end
