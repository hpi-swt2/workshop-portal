class AddImageToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :image, :string
  end
end
