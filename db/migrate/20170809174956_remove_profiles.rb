class RemoveProfiles < ActiveRecord::Migration

  def up
    drop_table :profiles
  end

  def down
    create_table "profiles", force: :cascade do |t|
      t.integer  "user_id",           null: false
      t.datetime "created_at",        null: false
      t.datetime "updated_at",        null: false
      t.string   "first_name"
      t.string   "last_name"
      t.string   "gender"
      t.date     "birth_date"
      t.string   "street_name"
      t.string   "zip_code"
      t.string   "city"
      t.string   "state"
      t.string   "country"
      t.text     "discovery_of_site"
    end
  end

end
