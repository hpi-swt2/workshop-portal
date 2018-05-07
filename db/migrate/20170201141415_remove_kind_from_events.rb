class RemoveKindFromEvents < ActiveRecord::Migration[4.2]
  def change
    remove_column :events, :kind, :string
  end
end
