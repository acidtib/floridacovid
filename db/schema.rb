# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_24_171836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counties", force: :cascade do |t|
    t.bigint "state_id"
    t.string "name"
    t.string "slug"
    t.integer "residents"
    t.integer "non_residents"
    t.integer "deaths"
    t.datetime "last_update"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "confirmed"
    t.integer "recovered"
    t.integer "deaths"
    t.datetime "last_update"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stats", force: :cascade do |t|
    t.bigint "state_id"
    t.integer "positive_residents"
    t.integer "cases_repatriated"
    t.integer "non_residents"
    t.integer "deaths"
    t.integer "results_negative"
    t.integer "results_pending"
    t.integer "being_monitored"
    t.integer "total_monitored"
    t.integer "recovered"
    t.string "last_update"
    t.integer "age_0_4"
    t.integer "age_5_14"
    t.integer "age_15_24"
    t.integer "age_25_34"
    t.integer "age_35_44"
    t.integer "age_45_54"
    t.integer "age_55_64"
    t.integer "age_65_74"
    t.integer "age_75_84"
    t.integer "age_85plus"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
