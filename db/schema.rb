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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20160831101225) do
=======
ActiveRecord::Schema.define(version: 20160831134721) do
>>>>>>> ea0ff4d18e5cbf661201dc57b0e8abb4d69062d6

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.boolean  "enable",            default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.string   "page_access_token"
    t.json     "info"
    t.string   "street"
    t.string   "city"
    t.string   "shop_name"
    t.string   "intent",            default: [],                 array: true
    t.index ["user_id"], name: "index_bots_on_user_id", using: :btree
  end

  create_table "histories", force: :cascade do |t|
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "bot_id"
    t.integer  "pattern_id"
    t.index ["bot_id"], name: "index_histories_on_bot_id", using: :btree
    t.index ["pattern_id"], name: "index_histories_on_pattern_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "product"
    t.string   "address"
    t.string   "status"
    t.integer  "bot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_orders_on_bot_id", using: :btree
  end

  create_table "patterns", force: :cascade do |t|
    t.string   "trigger"
    t.string   "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "bot_id"
    t.index ["bot_id"], name: "index_patterns_on_bot_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bot_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "photo"
    t.string   "price"
    t.index ["bot_id"], name: "index_products_on_bot_id", using: :btree
  end

  create_table "recoveries", force: :cascade do |t|
    t.string   "step"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sender_id"
    t.integer  "bot_id"
    t.index ["bot_id"], name: "index_recoveries_on_bot_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                  default: false
    t.string   "google_uid"
    t.string   "google_token"
    t.string   "google_email"
    t.integer  "expires_at"
    t.string   "refresh_token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bots", "users"
  add_foreign_key "histories", "bots"
  add_foreign_key "orders", "bots"
  add_foreign_key "patterns", "bots"
  add_foreign_key "products", "bots"
  add_foreign_key "recoveries", "bots"
end
