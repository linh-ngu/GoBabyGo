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

ActiveRecord::Schema[7.0].define(version: 2024_02_08_192347) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "car_types", force: :cascade do |t|
    t.integer "max_height"
    t.integer "min_height"
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

  create_table "finances", force: :cascade do |t|
    t.float "total_expense"
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
    t.string "child_name"
    t.date "child_birthdate"
    t.text "primary_diagnosis"
    t.string "secondary_diagnosis"
    t.integer "child_height"
    t.integer "child_weight"
    t.string "caregiver_name"
    t.string "caregiver_email"
    t.integer "caregiver_phone"
    t.boolean "can_transport"
    t.boolean "can_store"
    t.text "notes"
    t.integer "eligibility"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "adaptive_equipment"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.integer "level"
    t.integer "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end