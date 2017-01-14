class AddUnlimitedParticipantsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :participants_are_unlimited, :boolean, default: false
  end
end
