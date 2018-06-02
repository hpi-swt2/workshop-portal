class AddNumberOfParticipantsWithPreviousKnowledgeToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :number_of_participants_with_previous_knowledge, :integer
  end
end
