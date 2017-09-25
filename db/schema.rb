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

ActiveRecord::Schema.define(version: 20170925115834) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "match_player_performances", force: :cascade do |t|
    t.integer "runs"
    t.integer "balls"
    t.integer "fours"
    t.integer "sixes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tournament_player_id"
    t.bigint "match_predefined_team_id"
    t.integer "wickets"
    t.integer "maiden_overs"
    t.float "strike_rate"
    t.string "wicket_detail"
    t.float "overs"
    t.float "economy"
    t.integer "runs_conceded"
    t.integer "no_balls"
    t.integer "wide_balls"
    t.integer "inning"
    t.integer "catches", default: 0
    t.integer "run_outs", default: 0
    t.integer "stumpings", default: 0
    t.boolean "wicket_keeper", default: false
    t.index ["match_predefined_team_id"], name: "index_match_player_performances_on_match_predefined_team_id"
    t.index ["tournament_player_id"], name: "index_match_player_performances_on_tournament_player_id"
  end

  create_table "match_predefined_teams", force: :cascade do |t|
    t.bigint "predefined_tournament_team_id"
    t.bigint "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_predefined_teams_on_match_id"
    t.index ["predefined_tournament_team_id"], name: "index_match_predefined_teams_on_predefined_tournament_team_id"
  end

  create_table "match_team_players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tournament_player_id"
    t.bigint "match_team_id"
    t.index ["match_team_id"], name: "index_match_team_players_on_match_team_id"
    t.index ["tournament_player_id"], name: "index_match_team_players_on_tournament_player_id"
  end

  create_table "match_teams", force: :cascade do |t|
    t.integer "modifications_remaining", null: false
    t.integer "points_earned", default: 0, null: false
    t.bigint "team_id"
    t.bigint "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "captain_id"
    t.index ["match_id"], name: "index_match_teams_on_match_id"
    t.index ["team_id"], name: "index_match_teams_on_team_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "tournament_id"
    t.datetime "playing_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cricbuzz_match_url"
    t.boolean "approved", default: false
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.integer "role"
    t.string "country"
    t.string "batting_style"
    t.string "bowling_style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points_summaries", force: :cascade do |t|
    t.integer "format"
    t.integer "scoring_area"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predefined_teams", force: :cascade do |t|
    t.string "team_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predefined_tournament_teams", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "predefined_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["predefined_team_id"], name: "index_predefined_tournament_teams_on_predefined_team_id"
    t.index ["tournament_id"], name: "index_predefined_tournament_teams_on_tournament_id"
  end

  create_table "social_logins", force: :cascade do |t|
    t.bigint "user_id"
    t.string "email"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_social_logins_on_user_id"
  end

  create_table "team_players", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "tournament_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "captain", default: false
    t.index ["team_id"], name: "index_team_players_on_team_id"
    t.index ["tournament_player_id"], name: "index_team_players_on_tournament_player_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tournament_id"
    t.integer "modifications_remaining", null: false
    t.string "team_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points_earned", default: 0
    t.index ["tournament_id"], name: "index_teams_on_tournament_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "tournament_coins", force: :cascade do |t|
    t.bigint "tournament_id"
    t.integer "coins", null: false
    t.integer "start_standing", null: false
    t.integer "end_standing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_tournament_coins_on_tournament_id"
  end

  create_table "tournament_players", force: :cascade do |t|
    t.bigint "player_id"
    t.integer "budget_points", default: 7, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "predefined_tournament_team_id"
    t.index ["player_id"], name: "index_tournament_players_on_player_id"
    t.index ["predefined_tournament_team_id"], name: "index_tournament_players_on_predefined_tournament_team_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "title", null: false
    t.integer "format", null: false
    t.integer "modifications_limit", null: false
    t.integer "coins_required", null: false
    t.integer "budget", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cricbuzz_tournament_url"
    t.boolean "published", default: false
    t.boolean "coins_awarded", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "available_coins", default: 1000, null: false
    t.string "user_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "match_player_performances", "match_predefined_teams", on_delete: :cascade
  add_foreign_key "match_player_performances", "tournament_players", on_delete: :cascade
  add_foreign_key "match_predefined_teams", "matches", on_delete: :cascade
  add_foreign_key "match_predefined_teams", "predefined_tournament_teams", on_delete: :cascade
  add_foreign_key "match_team_players", "match_teams", on_delete: :cascade
  add_foreign_key "match_team_players", "tournament_players", on_delete: :cascade
  add_foreign_key "match_teams", "matches", on_delete: :cascade
  add_foreign_key "match_teams", "teams", on_delete: :cascade
  add_foreign_key "match_teams", "tournament_players", column: "captain_id", on_delete: :cascade
  add_foreign_key "matches", "tournaments", on_delete: :cascade
  add_foreign_key "predefined_tournament_teams", "predefined_teams", on_delete: :cascade
  add_foreign_key "predefined_tournament_teams", "tournaments", on_delete: :cascade
  add_foreign_key "social_logins", "users", on_delete: :cascade
  add_foreign_key "team_players", "teams", on_delete: :cascade
  add_foreign_key "team_players", "tournament_players", on_delete: :cascade
  add_foreign_key "teams", "tournaments", on_delete: :cascade
  add_foreign_key "teams", "users", on_delete: :cascade
  add_foreign_key "tournament_coins", "tournaments", on_delete: :cascade
  add_foreign_key "tournament_players", "players", on_delete: :cascade
  add_foreign_key "tournament_players", "predefined_tournament_teams", on_delete: :cascade
end
