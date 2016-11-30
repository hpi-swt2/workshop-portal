class AddKnowledgeLevelToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :knowledge_level, :string
  end
end
