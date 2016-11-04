# t.string   "name"
# t.string   "description"
# t.integer  "max_participants"
# t.boolean  "active"
# t.datetime "created_at",       null: false
# t.datetime "updated_at",       null: false

class Workshop < ActiveRecord::Base
  has_many :applications
end
