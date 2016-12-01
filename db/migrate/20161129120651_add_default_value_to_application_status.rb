class AddDefaultValueToApplicationStatus < ActiveRecord::Migration
  def change
	  change_column :application_letters, :status, :integer, null: false, default: 2
  end
end
