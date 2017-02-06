class AddAcceptancesHaveBeenSentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :acceptances_have_been_sent, :boolean, default: false
  end
end
