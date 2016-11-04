# t.string   "cv"
# t.integer  "user_id"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false

class Profile < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
end
