class AddCustomImageToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :custom_image, :string
  end
end
