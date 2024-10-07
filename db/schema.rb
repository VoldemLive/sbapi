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

ActiveRecord::Schema[7.1].define(version: 2024_09_26_022819) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dreams", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "datedream", default: -> { "CURRENT_TIMESTAMP" }
    t.text "description", default: ""
    t.integer "quality", default: 5
    t.boolean "deleted", default: false
    t.boolean "complete", default: false
    t.integer "hours", default: 8
    t.boolean "lucid", default: false
    t.string "tags", default: [], array: true
    t.string "lang", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complete"], name: "index_dreams_on_complete"
    t.index ["datedream"], name: "index_dreams_on_datedream"
    t.index ["deleted"], name: "index_dreams_on_deleted"
    t.index ["lucid"], name: "index_dreams_on_lucid"
    t.index ["quality"], name: "index_dreams_on_quality"
    t.index ["user_id"], name: "index_dreams_on_user_id"
  end

  create_table "interpretations", force: :cascade do |t|
    t.integer "dream_id", null: false
    t.string "lang", null: false
    t.string "meaning", default: ""
    t.string "tags", default: [], array: true
    t.string "questions", default: [], array: true
    t.text "jungian_perspective", default: ""
    t.text "freudian_perspective", default: ""
    t.boolean "loaded", default: false
    t.boolean "initiated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dreams", "users"
  add_foreign_key "interpretations", "dreams"
end
