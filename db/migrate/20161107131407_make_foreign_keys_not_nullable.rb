class MakeForeignKeysNotNullable < ActiveRecord::Migration
  def change
    change_column_null(:application_letters, :user_id, false)
    change_column_null(:application_letters, :workshop_id, false)
    
    change_column_null(:profiles, :user_id, false)
    
    change_column_null(:requests, :user_id, false)
  end
end
