class RemoveKindFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :kind, :string
  end
end
