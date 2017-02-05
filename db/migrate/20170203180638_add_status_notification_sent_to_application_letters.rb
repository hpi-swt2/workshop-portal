class AddStatusNotificationSentToApplicationLetters < ActiveRecord::Migration
  def change
    add_column :application_letters, :status_notification_sent, :boolean, default: false, null: false
  end
end
