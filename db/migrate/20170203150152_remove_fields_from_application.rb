class RemoveFieldsFromApplication < ActiveRecord::Migration
  def change
    remove_column :application_letters, :grade, :integer
    remove_column :application_letters, :coding_skills, :string
  end
end
