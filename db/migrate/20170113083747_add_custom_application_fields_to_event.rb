class AddCustomApplicationFieldsToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :custom_application_fields, :text
  end
end
