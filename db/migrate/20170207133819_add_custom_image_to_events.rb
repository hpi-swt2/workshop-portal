class AddCustomImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :custom_image, :string
  end
end
