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

ActiveRecord::Schema.define(version: 2020_02_27_073813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "imgurs", force: :cascade do |t|
    t.integer "instagram_id"
    t.string "type"
    t.string "file"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_imgurs_on_deleted_at"
    t.index ["type", "instagram_id"], name: "index_imgurs_on_type_and_instagram_id"
  end

  create_table "instagrams", force: :cascade do |t|
    t.string "content"
    t.integer "like_counter"
    t.datetime "deleted_at"
    t.bigint "user_id", null: false
    t.bigint "imgur_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_instagrams_on_deleted_at"
    t.index ["imgur_id"], name: "index_instagrams_on_imgur_id"
    t.index ["user_id"], name: "index_instagrams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "avatar"
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "instagrams", "imgurs"
  add_foreign_key "instagrams", "users"
end
