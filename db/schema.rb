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

ActiveRecord::Schema.define(:version => 20140408185134) do

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "dyndns_hostnames", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "dyndns_hostnames", ["user_id"], :name => "index_dyndns_hostnames_on_user_id"

  create_table "forwards", :force => true do |t|
    t.string   "name"
    t.string   "destination"
    t.integer  "domain_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "forwards", ["domain_id"], :name => "index_forwards_on_domain_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.integer  "domain_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "role"
    t.string   "forward_destination"
    t.string   "old_pwstring"
  end

  add_index "users", ["domain_id"], :name => "index_users_on_domain_id"

end
