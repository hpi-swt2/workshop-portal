class AddNameToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :name, :string
  end
end
