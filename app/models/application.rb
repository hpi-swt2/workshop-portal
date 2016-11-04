# t.string   "motivation"
# t.integer  "user_id"
# t.integer  "workshop_id"
# t.datetime "created_at",  null: false
# t.datetime "updated_at",  null: false

class Application < ActiveRecord::Base
  belongs_to :user
  belongs_to :workshop
end
