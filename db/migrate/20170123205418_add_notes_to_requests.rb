class AddNotesToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :notes, :text
  end
end
