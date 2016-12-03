class AddAdditionalInformationToApplicationLetter < ActiveRecord::Migration
  def change
    add_column :application_letters, :grade, :integer
    add_column :application_letters, :experience, :string
    add_column :application_letters, :coding_skills, :string
    add_column :application_letters, :emergency_number, :string
    add_column :application_letters, :vegeterian, :boolean
    add_column :application_letters, :vegan, :boolean
    add_column :application_letters, :allergic, :boolean
    add_column :application_letters, :allergies, :string
  end
end
