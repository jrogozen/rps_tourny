# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141003102141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_players", force: true do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.string  "status",    default: "active"
  end

  create_table "games", force: true do |t|
    t.string  "winner"
    t.string  "loser"
    t.integer "tournament_id"
    t.string  "status",        default: "active"
  end

  create_table "moves", force: true do |t|
    t.string  "move"
    t.integer "game_id"
    t.integer "player_id"
  end

  add_index "moves", ["player_id"], name: "index_moves_on_player_id", using: :btree

  create_table "players", force: true do |t|
    t.string  "username"
    t.string  "email"
    t.integer "wins",     default: 0
    t.integer "losses",   default: 0
  end

  create_table "tournament_players", force: true do |t|
    t.integer "tournament_id"
    t.integer "player_id"
    t.string  "status",        default: "active"
  end

  create_table "tournaments", force: true do |t|
    t.string "name"
    t.string "winner"
  end

end
