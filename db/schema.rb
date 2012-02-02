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

ActiveRecord::Schema.define(:version => 20120201173709) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.string   "link"
    t.integer  "likes"
    t.string   "category"
    t.text     "website"
    t.string   "personal_info"
    t.integer  "talking_about_count"
    t.integer  "fb_id",               :limit => 8
  end

  create_table "comment_ids", :force => true do |t|
    t.integer  "brand_id",   :limit => 8
    t.integer  "post_id",    :limit => 8
    t.integer  "comment_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "comment_id",   :limit => 8
    t.string   "from_name"
    t.integer  "from_id",      :limit => 8
    t.string   "message"
    t.datetime "created_time"
    t.integer  "likes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_ids", :force => true do |t|
    t.integer  "post_id",    :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id",   :limit => 8
    t.boolean  "has_post",                :default => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "post_id",           :limit => 8
    t.string   "message"
    t.string   "picture"
    t.string   "link"
    t.string   "name"
    t.string   "caption"
    t.string   "description"
    t.string   "icon"
    t.string   "type"
    t.datetime "post_created_time"
    t.datetime "post_updated_time"
    t.integer  "likes_count"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id",          :limit => 8
    t.datetime "comment_check"
  end

  create_table "users", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "link"
    t.string   "username"
    t.string   "gender"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
