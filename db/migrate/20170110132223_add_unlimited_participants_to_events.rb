class AddUnlimitedParticipantsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :participants_are_unlimited, :boolean
  end
end
