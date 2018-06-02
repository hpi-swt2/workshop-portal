class AddDefaultValueToHidden < ActiveRecord::Migration[4.2]
  def up
    change_column :events, :hidden, :boolean, :default => false
  end

  def down
    change_column :events, :hidden, :boolean, :default => nil
  end
end
