class CreateWorkshops < ActiveRecord::Migration
  def change
    create_table :workshops do |t|
      t.string :name
      t.string :description
      t.integer :max_participants
      t.boolean :active

      t.timestamps null: false
    end
  end
end
