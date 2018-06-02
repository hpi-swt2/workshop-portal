class RemoveActiveFromEvent < ActiveRecord::Migration[4.2]
  def change
    remove_column :events, :active, :boolean
  end
end
