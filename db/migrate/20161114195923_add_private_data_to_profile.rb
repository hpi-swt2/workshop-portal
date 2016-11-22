class AddPrivateDataToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
    add_column :profiles, :gender, :string
    add_column :profiles, :birth_date, :date
    add_column :profiles, :email, :string
    add_column :profiles, :school, :string
    add_column :profiles, :street_name, :string
    add_column :profiles, :zip_code, :string
    add_column :profiles, :city, :string
    add_column :profiles, :state, :string
    add_column :profiles, :country, :string
    add_column :profiles, :graduates_school_in, :string
  end
end
