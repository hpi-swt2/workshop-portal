class RemoveParticipantsAreUnlimitedFromEvents < ActiveRecord::Migration[4.2]
  def change
    remove_column :events, :participants_are_unlimited, :boolean
  end
end
