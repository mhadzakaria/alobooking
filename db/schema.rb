# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_10_151803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gist"
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.string "status", default: "upcoming", null: false
    t.string "cancelled_by"
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id", "patient_id", "start_at"], name: "index_appointments_no_duplicate_booking", unique: true, where: "((status)::text <> 'cancelled'::text)"
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["start_at"], name: "index_appointments_on_start_at"
    t.exclusion_constraint "doctor_id WITH =, tsrange(start_at, end_at) WITH &&", where: "(status)::text <> 'cancelled'::text", using: :gist, name: "no_overlapping_appointments"
  end

  create_table "doctor_schedules", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.integer "day_of_week", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id", "day_of_week"], name: "index_doctor_schedules_on_doctor_id_and_day_of_week"
    t.index ["doctor_id"], name: "index_doctor_schedules_on_doctor_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointments", "doctors"
  add_foreign_key "appointments", "patients"
  add_foreign_key "doctor_schedules", "doctors"
end
