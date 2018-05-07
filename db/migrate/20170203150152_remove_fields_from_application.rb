class RemoveFieldsFromApplication < ActiveRecord::Migration[4.2]
  def change
    remove_column :application_letters, :grade, :integer
    remove_column :application_letters, :coding_skills, :string
  end
end
