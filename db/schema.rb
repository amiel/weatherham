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

ActiveRecord::Schema.define(:version => 20120911030545) do

  create_table "fetches", :force => true do |t|
    t.datetime "start_at"
    t.datetime "finish_at"
    t.integer  "observation_id"
    t.boolean  "error",          :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "observations", :force => true do |t|
    t.datetime "observed_at"
    t.float    "temp"
    t.float    "hi_temp"
    t.float    "low_temp"
    t.integer  "humidity"
    t.float    "dew_point"
    t.float    "wind_speed"
    t.string   "wind_dir"
    t.float    "wind_run"
    t.float    "hi_speed"
    t.string   "hi_dir"
    t.float    "wind_chill"
    t.float    "barometer"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.float    "rain"
  end

end
