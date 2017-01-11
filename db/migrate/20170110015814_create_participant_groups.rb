class CreateParticipantGroups < ActiveRecord::Migration
  def change
    create_table :participant_groups do |t|
      t.references :application_letter, index: true, foreign_key: true
      t.integer :group
    end
  end
end
