class RemoveExperienceFromApplicationLetters < ActiveRecord::Migration
  def change
  	remove_column :application_letters, :experience, :string
  end
end
