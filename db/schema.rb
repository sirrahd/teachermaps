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

ActiveRecord::Schema.define(:version => 20130303003444) do

  create_table "course_grades", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "course_grades_maps", :id => false, :force => true do |t|
    t.integer "course_grade_id"
    t.integer "map_id"
  end

  add_index "course_grades_maps", ["course_grade_id", "map_id"], :name => "course_grades_maps_index"
  add_index "course_grades_maps", ["map_id", "course_grade_id"], :name => "maps_course_grades_index"

  create_table "course_grades_resources", :id => false, :force => true do |t|
    t.integer "course_grade_id"
    t.integer "resource_id"
  end

  add_index "course_grades_resources", ["course_grade_id", "resource_id"], :name => "course_grades_resources_index"
  add_index "course_grades_resources", ["resource_id", "course_grade_id"], :name => "resources_course_grades_index"

  create_table "course_grades_standards", :id => false, :force => true do |t|
    t.integer "course_grade_id"
    t.integer "standard_id"
  end

  add_index "course_grades_standards", ["course_grade_id", "standard_id"], :name => "course_grades_standards_index"
  add_index "course_grades_standards", ["standard_id", "course_grade_id"], :name => "standards_course_grades_index"

  create_table "course_subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "course_subjects_maps", :id => false, :force => true do |t|
    t.integer "course_subject_id"
    t.integer "map_id"
  end

  add_index "course_subjects_maps", ["course_subject_id", "map_id"], :name => "course_subjects_maps_index"
  add_index "course_subjects_maps", ["map_id", "course_subject_id"], :name => "maps_course_subjects_index"

  create_table "course_subjects_resources", :id => false, :force => true do |t|
    t.integer "course_subject_id"
    t.integer "resource_id"
  end

  add_index "course_subjects_resources", ["course_subject_id", "resource_id"], :name => "course_subjects_resources_index"
  add_index "course_subjects_resources", ["resource_id", "course_subject_id"], :name => "resources_course_subjects_index"

  create_table "drop_box_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_token"
    t.string   "file_hash"
    t.string   "cursor"
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

  create_table "map_assessments", :force => true do |t|
    t.string   "assessment_text"
    t.string   "rubric_text"
    t.integer  "user_id"
    t.integer  "map"
    t.integer  "assessment_resource_id"
    t.integer  "rubric_resource_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "map_objectives", :force => true do |t|
    t.string   "name"
    t.string   "text"
    t.string   "slug"
    t.integer  "map_standard_id"
    t.integer  "user_id"
    t.integer  "map_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "map_resources", :force => true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "resource_id"
    t.integer  "map_id"
    t.integer  "map_objective_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "map_standards", :force => true do |t|
    t.string   "slug"
    t.integer  "standard_id"
    t.integer  "map_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "text"
    t.string   "thumbnail"
    t.integer  "resources_count"
    t.integer  "objectives_count"
    t.integer  "standards_count"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "resource_types", :force => true do |t|
    t.string "name"
    t.string "thumbnail"
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
    t.string   "link"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.integer  "resource_type_id"
  end

  create_table "settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "upload_to"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "standard_types", :force => true do |t|
    t.string "name"
  end

  create_table "standards", :force => true do |t|
    t.string  "name"
    t.string  "text"
    t.string  "domain"
    t.string  "sub_subject"
    t.string  "slug"
    t.integer "course_grade_id"
    t.integer "course_subject_id"
    t.integer "standard_type_id"
    t.integer "parent_standard_id"
    t.boolean "is_parent_standard"
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
