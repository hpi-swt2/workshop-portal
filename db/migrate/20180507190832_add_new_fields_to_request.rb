class AddNewFieldsToRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :study_info, :boolean
    add_column :requests, :campus_tour, :boolean
  end
end
