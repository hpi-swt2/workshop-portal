class ChangeAddressFields < ActiveRecord::Migration
  def change
    rename_column :requests, :address, :street
    add_column :requests, :zip_code_city, :string
  end
end
