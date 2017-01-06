class AddFieldsToRequests < ActiveRecord::Migration
  def change
    remove_column :requests, :topics, :string
    remove_column :requests, :user_id, :integer
    add_column :requests, :form_of_address, :integer
    add_column :requests, :first_name, :string
    add_column :requests, :last_name, :string
    add_column :requests, :phone_number, :string
    add_column :requests, :address, :string
    add_column :requests, :email, :string
    add_column :requests, :topic_of_workshop, :text
    add_column :requests, :time_period, :text
    add_column :requests, :number_of_participants, :integer
    add_column :requests, :knowledge_level, :string
    add_column :requests, :annotations, :text
  end
end
