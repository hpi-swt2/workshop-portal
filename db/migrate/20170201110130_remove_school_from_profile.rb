class RemoveSchoolFromProfile < ActiveRecord::Migration[4.2]
  def change
    remove_column :profiles, :school, :string
    remove_column :profiles, :graduates_school_in, :string
    add_column :application_letters, :organisation, :string
  end
end
