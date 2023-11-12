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

ActiveRecord::Schema[7.0].define(version: 2023_11_12_001621) do
  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "neighborhood"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inn_additionals", force: :cascade do |t|
    t.text "description"
    t.text "policies"
    t.time "check_in"
    t.time "check_out"
    t.boolean "pets", default: false
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_inn_additionals_on_inn_id"
  end

  create_table "inns", force: :cascade do |t|
    t.string "name"
    t.string "social_name"
    t.string "cnpj"
    t.string "phone"
    t.string "email"
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "user_id", null: false
    t.index ["address_id"], name: "index_inns_on_address_id"
    t.index ["user_id"], name: "index_inns_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.integer "inn_additional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_additional_id"], name: "index_payment_methods_on_inn_additional_id"
  end

  create_table "price_periods", force: :cascade do |t|
    t.integer "value"
    t.date "start_date"
    t.date "end_date"
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_price_periods_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "dimension"
    t.integer "max_occupancy"
    t.integer "value"
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bathroom", default: false
    t.boolean "balcony", default: false
    t.boolean "air_conditioning", default: false
    t.boolean "tv", default: false
    t.boolean "wardrobe", default: false
    t.boolean "safe", default: false
    t.boolean "accessible", default: false
    t.integer "status"
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "innkeeper", default: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "inn_additionals", "inns"
  add_foreign_key "inns", "addresses"
  add_foreign_key "inns", "users"
  add_foreign_key "payment_methods", "inn_additionals"
  add_foreign_key "price_periods", "rooms"
  add_foreign_key "rooms", "inns"
end
