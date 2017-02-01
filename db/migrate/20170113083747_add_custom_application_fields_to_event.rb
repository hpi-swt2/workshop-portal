class AddCustomApplicationFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :custom_application_fields, :text
  end
end
