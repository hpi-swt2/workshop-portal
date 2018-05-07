class RemoveApplicationStatusLockedFromEvents < ActiveRecord::Migration[4.2]
  def change
    remove_column :events, :application_status_locked, :boolean
  end
end
