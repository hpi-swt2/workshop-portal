class AddApplicationDeadlineToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :application_deadline, :date
  end
end
