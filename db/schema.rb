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

ActiveRecord::Schema[7.0].define(version: 303) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "schedule_availabilities", force: :cascade do |t|
    t.integer "day", null: false
    t.boolean "hour00", default: false
    t.boolean "hour01", default: false
    t.boolean "hour02", default: false
    t.boolean "hour03", default: false
    t.boolean "hour04", default: false
    t.boolean "hour05", default: false
    t.boolean "hour06", default: false
    t.boolean "hour07", default: false
    t.boolean "hour08", default: false
    t.boolean "hour09", default: false
    t.boolean "hour10", default: false
    t.boolean "hour11", default: false
    t.boolean "hour12", default: false
    t.boolean "hour13", default: false
    t.boolean "hour14", default: false
    t.boolean "hour15", default: false
    t.boolean "hour16", default: false
    t.boolean "hour17", default: false
    t.boolean "hour18", default: false
    t.boolean "hour19", default: false
    t.boolean "hour20", default: false
    t.boolean "hour21", default: false
    t.boolean "hour22", default: false
    t.boolean "hour23", default: false
    t.bigint "user_id", null: false
    t.bigint "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_schedule_availabilities_on_schedule_id"
    t.index ["user_id"], name: "index_schedule_availabilities_on_user_id"
  end

  create_table "schedule_results", force: :cascade do |t|
    t.bigint "day", null: false
    t.bigint "hour00"
    t.bigint "hour01"
    t.bigint "hour02"
    t.bigint "hour03"
    t.bigint "hour04"
    t.bigint "hour05"
    t.bigint "hour06"
    t.bigint "hour07"
    t.bigint "hour08"
    t.bigint "hour09"
    t.bigint "hour10"
    t.bigint "hour11"
    t.bigint "hour12"
    t.bigint "hour13"
    t.bigint "hour14"
    t.bigint "hour15"
    t.bigint "hour16"
    t.bigint "hour17"
    t.bigint "hour18"
    t.bigint "hour19"
    t.bigint "hour20"
    t.bigint "hour21"
    t.bigint "hour22"
    t.bigint "hour23"
    t.bigint "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_schedule_results_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "week", null: false
    t.integer "mon_hour_start"
    t.integer "mon_hour_end"
    t.integer "tue_hour_start"
    t.integer "tue_hour_end"
    t.integer "wed_hour_start"
    t.integer "wed_hour_end"
    t.integer "thu_hour_start"
    t.integer "thu_hour_end"
    t.integer "fri_hour_start"
    t.integer "fri_hour_end"
    t.integer "sat_hour_start"
    t.integer "sat_hour_end"
    t.integer "sun_hour_start"
    t.integer "sun_hour_end"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_schedules_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  create_table "user_details", force: :cascade do |t|
    t.string "first_names"
    t.string "last_names"
    t.datetime "birth_date"
    t.text "address"
    t.text "personal_phone"
    t.text "emergency_phone"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "encrypted_password", null: false
    t.string "email"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "schedule_availabilities", "schedules"
  add_foreign_key "schedule_availabilities", "users"
  add_foreign_key "schedule_results", "schedules"
  add_foreign_key "schedules", "services"
  add_foreign_key "user_details", "users"
end
