class RemoveActiveFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :active, :boolean
  end
end
