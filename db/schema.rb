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

ActiveRecord::Schema.define(version: 20170727054830) do

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.integer "role", null: false
    t.string "country", null: false
    t.string "batting_style", null: false
    t.string "bowling_style", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournament_players", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "player_id"
    t.integer "budget_points", null: false
    t.string "team_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_tournament_players_on_player_id"
    t.index ["tournament_id"], name: "index_tournament_players_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "title", null: false
    t.string "format", null: false
    t.integer "modifications_limit", null: false
    t.integer "coins_required", null: false
    t.integer "budget", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end