class AddKnowledgeLevelToWorkshops < ActiveRecord::Migration[4.2]
  def self.up
    add_column :events, :knowledge_level, :string unless column_exists?(:events, :knowledge_level)
  end

  def self.down
    Profile.reset_column_information
    remove_column :events, :knowledge_level, :string if column_exists?(:events, :knowledge_level)
  end
end
