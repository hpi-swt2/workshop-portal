class AddKnowledgeLevelToWorkshops < ActiveRecord::Migration
  def change
    add_column :events, :knowledge_level, :string
  end
end
