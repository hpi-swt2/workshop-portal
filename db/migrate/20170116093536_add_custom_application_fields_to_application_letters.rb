class AddCustomApplicationFieldsToApplicationLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :application_letters, :custom_application_fields, :text
  end
end
