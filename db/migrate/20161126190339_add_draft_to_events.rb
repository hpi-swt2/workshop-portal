class AddDraftToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :draft, :boolean
  end
end
