class AddAcceptancesHaveBeenSentToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :acceptances_have_been_sent, :boolean, default: false
  end
end
