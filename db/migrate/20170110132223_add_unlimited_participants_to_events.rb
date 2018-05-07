class AddUnlimitedParticipantsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :participants_are_unlimited, :boolean, default: false
  end
end
