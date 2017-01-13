class RenameDraftToPublished < ActiveRecord::Migration
  def change
    rename_column :events, :draft, :published
  end
end
