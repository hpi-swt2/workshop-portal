# t.string   "topics"
# t.integer  "user_id"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false

class Request < ActiveRecord::Base
  belongs_to :user
end
