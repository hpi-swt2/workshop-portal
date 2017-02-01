class CreateParticipantGroups < ActiveRecord::Migration
  def change
    create_table :participant_groups do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.integer :group, null: false
    end
  end
end
