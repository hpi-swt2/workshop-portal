class RemoveSchoolFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :school, :string
    remove_column :profiles, :graduates_school_in, :string
    add_column :application_letters, :organisation, :string
  end
end
