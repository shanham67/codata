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

ActiveRecord::Schema.define(:version => 20110128034800) do

  create_table "email_addresses", :force => true do |t|
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.date     "begin_date"
    t.date     "end_date"
    t.integer  "active_party_id"
    t.date     "superceded_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "party_names", :force => true do |t|
    t.integer  "party_id"
    t.string   "function"
    t.string   "surname"
    t.string   "rest_of_name"
    t.string   "prefix"
    t.string   "suffix"
    t.date     "first_used_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "party_relationship_types", :force => true do |t|
    t.string   "description"
    t.string   "first_party_role"
    t.string   "second_party_role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "party_relationships", :force => true do |t|
    t.integer  "first_party_id"
    t.integer  "second_party_id"
    t.integer  "party_relationship_type_id"
    t.date     "begin_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", :force => true do |t|
    t.string   "description"
    t.integer  "callable_id"
    t.string   "callable_type"
    t.string   "dial_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_id_definitions", :force => true do |t|
    t.integer  "party_id"
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
