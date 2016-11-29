class CreateApplicationNotes < ActiveRecord::Migration
  def change
    create_table :application_notes do |t|
      t.text :note
      t.references :application_letter, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
