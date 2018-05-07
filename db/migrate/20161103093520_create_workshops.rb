class CreateWorkshops < ActiveRecord::Migration[4.2]
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
