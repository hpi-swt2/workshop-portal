class AddGradeToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :grade, :string
  end
end
