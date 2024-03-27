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

ActiveRecord::Schema[7.0].define(version: 2024_03_26_232146) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "user_account_created", default: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "application_notes", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_application_id", null: false
    t.index ["user_application_id"], name: "index_application_notes_on_user_application_id"
  end

  create_table "car_types", force: :cascade do |t|
    t.integer "max_height"
    t.integer "max_weight"
    t.string "name"
    t.float "price"
    t.integer "quantity_purchased"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cars", force: :cascade do |t|
    t.text "modification_details"
    t.boolean "complete"
    t.float "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "car_type_id"
    t.integer "user_application_id"
    t.integer "finance_id"
  end

  create_table "cars_parts", id: false, force: :cascade do |t|
    t.bigint "car_id"
    t.bigint "part_id"
    t.index ["car_id"], name: "index_cars_parts_on_car_id"
    t.index ["part_id"], name: "index_cars_parts_on_part_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finances", force: :cascade do |t|
    t.float "total_expense"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.integer "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string "part_name"
    t.float "part_price"
    t.string "purchase_source"
    t.integer "quantity_purchased"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "car_id"
  end

  create_table "user_applications", force: :cascade do |t|
    t.date "child_birthdate"
    t.text "primary_diagnosis"
    t.string "secondary_diagnosis"
    t.integer "child_height"
    t.integer "child_weight"
    t.string "caregiver_email"
    t.bigint "caregiver_phone"
    t.boolean "can_transport"
    t.boolean "can_store"
    t.text "notes"
    t.integer "eligibility"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "adaptive_equipment"
    t.boolean "waitlist", default: false
    t.string "child_first_name"
    t.string "child_last_name"
    t.string "caregiver_first_name"
    t.string "caregiver_last_name"
    t.string "build_session"
    t.boolean "archived", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.integer "level", default: 0
    t.bigint "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id"
    t.string "first_name"
    t.string "last_name"
  end

  add_foreign_key "application_notes", "user_applications"
end
