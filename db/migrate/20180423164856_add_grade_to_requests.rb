class AddGradeToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :grade, :string
  end
end
