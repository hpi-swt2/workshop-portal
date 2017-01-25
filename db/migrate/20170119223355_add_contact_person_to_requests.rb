class AddContactPersonToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :contact_person, :string
  end
end
