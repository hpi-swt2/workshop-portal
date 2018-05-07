class AddStatusToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :status, :integer, default: 0
  end
end
