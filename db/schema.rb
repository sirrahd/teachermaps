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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130111021632) do

  create_table "drop_box_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_token"
    t.string   "type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "google_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "expires_in"
    t.string   "issued_at"
    t.string   "folder_id"
    t.string   "largest_change_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "resources", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "mime_type"
    t.string   "file_size"
    t.string   "size"
    t.string   "file_id"
    t.string   "rev"
    t.string   "path"
    t.string   "file_hash"
    t.string   "modified"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "settings", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "account_name"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["account_name"], :name => "index_users_on_account_name", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
