class ChangeRequestDescriptionToTextfield < ActiveRecord::Migration
  def change
    change_column :events, :description, :text
  end
end
