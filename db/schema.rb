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

ActiveRecord::Schema.define(version: 2020_04_06_021340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_stats", force: :cascade do |t|
    t.bigint "state_id"
    t.bigint "a_0_4"
    t.bigint "a_5_14"
    t.bigint "a_15_24"
    t.bigint "a_25_34"
    t.bigint "a_35_44"
    t.bigint "a_45_54"
    t.bigint "a_55_64"
    t.bigint "a_65_74"
    t.bigint "a_75_84"
    t.bigint "a_85plus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_age_stats_on_state_id"
  end

  create_table "counties", force: :cascade do |t|
    t.bigint "state_id"
    t.string "name"
    t.string "slug"
    t.string "lat"
    t.string "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_counties_on_state_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "lat"
    t.string "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "country_stats", force: :cascade do |t|
    t.bigint "country_id"
    t.bigint "confirmed"
    t.bigint "recovered"
    t.bigint "deaths"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_stats_on_country_id"
  end

  create_table "county_stats", force: :cascade do |t|
    t.bigint "county_id"
    t.bigint "residents"
    t.bigint "non_residents"
    t.bigint "deaths"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_county_stats_on_county_id"
  end

  create_table "state_stats", force: :cascade do |t|
    t.bigint "state_id"
    t.bigint "positive_residents"
    t.bigint "positive_non_residents"
    t.bigint "deaths"
    t.bigint "results_total"
    t.bigint "results_negative"
    t.bigint "recovered"
    t.bigint "being_monitored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_state_stats_on_state_id"
  end

  create_table "states", force: :cascade do |t|
    t.bigint "country_id"
    t.string "name"
    t.string "slug"
    t.string "lat"
    t.string "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  add_foreign_key "age_stats", "states"
  add_foreign_key "counties", "states"
  add_foreign_key "country_stats", "countries"
  add_foreign_key "county_stats", "counties"
  add_foreign_key "state_stats", "states"
  add_foreign_key "states", "countries"
end
