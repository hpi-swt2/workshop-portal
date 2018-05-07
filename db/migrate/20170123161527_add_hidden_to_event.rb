class AddHiddenToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :hidden, :boolean
  end
end
