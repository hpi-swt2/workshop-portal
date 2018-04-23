class RenameAddress < ActiveRecord::Migration
  def change
    rename_column :requests, :street, :school_street
    rename_column :requests, :zip_code_city, :school_zip_code_city
  end
end
