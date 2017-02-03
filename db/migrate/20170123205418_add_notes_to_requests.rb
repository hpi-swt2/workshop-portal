class AddNotesToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :notes, :text
  end
end
