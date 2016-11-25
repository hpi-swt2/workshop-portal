class AddDateRangesToEvent < ActiveRecord::Migration
  def change
    create_table :date_ranges do |t|
      t.date :start_date
      t.date :end_date
      t.integer :event_id
      t.timestamps
      t.belongs_to :event, index: true
    end
  end
end
