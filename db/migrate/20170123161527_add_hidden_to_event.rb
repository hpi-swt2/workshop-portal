class AddHiddenToEvent < ActiveRecord::Migration
  def change
    add_column :events, :hidden, :boolean
  end
end
