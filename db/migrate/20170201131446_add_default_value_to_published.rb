class AddDefaultValueToPublished < ActiveRecord::Migration
  def up
    change_column :events, :published, :boolean, :default => false
  end

  def down
    change_column :events, :published, :boolean, :default => nil
  end
end
