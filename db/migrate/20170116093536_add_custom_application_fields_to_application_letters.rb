class AddCustomApplicationFieldsToApplicationLetters < ActiveRecord::Migration
  def change
    add_column :application_letters, :custom_application_fields, :text
  end
end
