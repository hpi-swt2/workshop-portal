class RemoveParticipantsAreUnlimitedFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :participants_are_unlimited, :boolean
  end
end
