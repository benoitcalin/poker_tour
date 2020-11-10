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

ActiveRecord::Schema.define(version: 2020_11_09_151740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "winamax_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float "total_registrations"
    t.float "total_reentries"
    t.float "buyin"
    t.float "rake"
    t.float "bounty"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tournament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_id"], name: "index_participations_on_tournament_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "results", force: :cascade do |t|
    t.float "position"
    t.float "reentries", default: 0.0, null: false
    t.float "earnings"
    t.float "bounties", default: 0.0, null: false
    t.float "kills", default: 0.0, null: false
    t.bigint "player_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_results_on_game_id"
    t.index ["player_id"], name: "index_results_on_player_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "tournament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_sessions_on_game_id"
    t.index ["tournament_id"], name: "index_sessions_on_tournament_id"
  end

  create_table "tournament_results", force: :cascade do |t|
    t.float "games"
    t.float "average_position"
    t.float "reentries"
    t.float "bets"
    t.float "kills"
    t.float "bounties"
    t.float "earnings"
    t.float "net_earnings"
    t.float "earnings_by_game"
    t.bigint "player_id", null: false
    t.bigint "tournament_id", null: false
    t.index ["player_id"], name: "index_tournament_results_on_player_id"
    t.index ["tournament_id"], name: "index_tournament_results_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_tournaments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "winamax_name", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "participations", "tournaments"
  add_foreign_key "participations", "users"
  add_foreign_key "results", "games"
  add_foreign_key "results", "players"
  add_foreign_key "sessions", "games"
  add_foreign_key "sessions", "tournaments"
  add_foreign_key "tournament_results", "players"
  add_foreign_key "tournament_results", "tournaments"
  add_foreign_key "tournaments", "users"
end
