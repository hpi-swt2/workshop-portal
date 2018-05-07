class CreateApplications < ActiveRecord::Migration[4.2]
  def change
    create_table :applications do |t|
      t.string :motivation
      t.references :user, index: true, foreign_key: true
      t.references :workshop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
