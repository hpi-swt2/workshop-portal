class AddContactPersonToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :contact_person, :string
  end
end
