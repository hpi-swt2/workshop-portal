class RemoveExperienceFromApplicationLetters < ActiveRecord::Migration[4.2]
  def change
  	remove_column :application_letters, :experience, :string
  end
end
