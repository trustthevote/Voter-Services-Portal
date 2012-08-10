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

ActiveRecord::Schema.define(:version => 20120810114104) do

  create_table "log_records", :force => true do |t|
    t.string   "action"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "voter_id"
    t.string   "doctype"
    t.string   "voter_type"
  end

  add_index "log_records", ["created_at"], :name => "index_log_records_on_created_at"

  create_table "offices", :force => true do |t|
    t.string "locality", :null => false
    t.string "address",  :null => false
  end

  add_index "offices", ["locality"], :name => "index_offices_on_locality", :unique => true

  create_table "registrations", :force => true do |t|
    t.text     "data"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "previous_data"
  end

  create_table "settings", :force => true do |t|
    t.string "name",  :null => false
    t.string "value"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

end
