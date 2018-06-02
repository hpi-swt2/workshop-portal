class AddDefaultValueToPublished < ActiveRecord::Migration[4.2]
  def up
    change_column :events, :published, :boolean, :default => false
  end

  def down
    change_column :events, :published, :boolean, :default => nil
  end
end
