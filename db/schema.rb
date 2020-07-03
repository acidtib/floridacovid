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

ActiveRecord::Schema.define(version: 2020_07_03_025202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_stats", force: :cascade do |t|
    t.bigint "state_id"
    t.bigint "a_0_4", default: 0
    t.bigint "a_5_14", default: 0
    t.bigint "a_15_24", default: 0
    t.bigint "a_25_34", default: 0
    t.bigint "a_35_44", default: 0
    t.bigint "a_45_54", default: 0
    t.bigint "a_55_64", default: 0
    t.bigint "a_65_74", default: 0
    t.bigint "a_75_84", default: 0
    t.bigint "a_85plus", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_age_stats_on_state_id"
  end

  create_table "cases", force: :cascade do |t|
    t.integer "object_id"
    t.bigint "county_id"
    t.bigint "state_id"
    t.string "age"
    t.string "age_group"
    t.string "gender"
    t.string "jurisdiction"
    t.string "travel_related"
    t.string "origin"
    t.string "ed_visit"
    t.string "hospitalized"
    t.string "died"
    t.string "case_"
    t.string "contact"
    t.datetime "case_date"
    t.datetime "event_date"
    t.datetime "chart_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_cases_on_county_id"
    t.index ["state_id"], name: "index_cases_on_state_id"
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
    t.bigint "confirmed", default: 0
    t.bigint "recovered", default: 0
    t.bigint "deaths", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_stats_on_country_id"
  end

  create_table "county_stats", force: :cascade do |t|
    t.bigint "county_id"
    t.bigint "residents", default: 0
    t.bigint "non_residents", default: 0
    t.bigint "deaths", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_county_stats_on_county_id"
  end

  create_table "state_stats", force: :cascade do |t|
    t.bigint "state_id"
    t.bigint "positive_residents", default: 0
    t.bigint "positive_non_residents", default: 0
    t.bigint "deaths", default: 0
    t.bigint "results_total", default: 0
    t.bigint "results_negative", default: 0
    t.bigint "recovered", default: 0
    t.bigint "being_monitored", default: 0
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
  add_foreign_key "cases", "counties"
  add_foreign_key "cases", "states"
  add_foreign_key "counties", "states"
  add_foreign_key "country_stats", "countries"
  add_foreign_key "county_stats", "counties"
  add_foreign_key "state_stats", "states"
  add_foreign_key "states", "countries"
end
