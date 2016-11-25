# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.


ActiveRecord::Schema.define(version: 20161123124500) do

  create_table "application_letters", force: :cascade do |t|
    t.string   "motivation"
    t.integer  "user_id",    null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "application_letters", ["event_id"], name: "index_application_letters_on_event_id"
  add_index "application_letters", ["user_id"], name: "index_application_letters_on_user_id"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "max_participants"
    t.boolean  "active"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "application_notes", force: :cascade do |t|
    t.text     "note"
    t.integer  "application_letter_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "application_notes", ["application_letter_id"], name: "index_application_notes_on_application_letter_id"

  create_table "profiles", force: :cascade do |t|
    t.string   "cv"
    t.integer  "user_id",             null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birth_date"
    t.string   "email"
    t.string   "school"
    t.string   "street_name"
    t.string   "zip_code"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "graduates_school_in"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "requests", force: :cascade do |t|
    t.string   "topics"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "requests", ["user_id"], name: "index_requests_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
