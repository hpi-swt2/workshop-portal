class AddInformationToApplicationLetter < ActiveRecord::Migration
  def change
    add_column :application_letters, :first_name, :string
    add_column :application_letters, :last_name, :string
    add_column :application_letters, :birth_date, :date
    add_column :application_letters, :street_name, :string
    add_column :application_letters, :zip_code, :string
    add_column :application_letters, :city, :string
    add_column :application_letters, :country, :string
    add_column :application_letters, :discovery_of_site, :text
  end
end
