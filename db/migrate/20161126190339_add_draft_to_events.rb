class AddDraftToEvents < ActiveRecord::Migration
  def change
    add_column :events, :draft, :boolean
  end
end
