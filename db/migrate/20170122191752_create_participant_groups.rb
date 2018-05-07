class CreateParticipantGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :participant_groups do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.integer :group, null: false
    end
  end
end
