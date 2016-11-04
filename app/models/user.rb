# t.string   "email",                  default: "", null: false
# t.string   "encrypted_password",     default: "", null: false
# t.string   "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.integer  "sign_in_count",          default: 0,  null: false
# t.datetime "current_sign_in_at"
# t.datetime "last_sign_in_at"
# t.string   "current_sign_in_ip"
# t.string   "last_sign_in_ip"
# t.datetime "created_at",                          null: false
# t.datetime "updated_at",                          null: false
# t.string   "name"

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  has_many :applications
  has_many :requests
end
