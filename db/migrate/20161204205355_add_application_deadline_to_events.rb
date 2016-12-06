class AddApplicationDeadlineToEvents < ActiveRecord::Migration
  def change
    add_column :events, :application_deadline, :date
  end
end
