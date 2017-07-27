class Player < ApplicationRecord
  has_many :tournament_players
  has_many :tournaments, through: :tournament_players

  enum role: {
    batsman: 1,
    bowler: 2,
    wk: 3,
    all_rounder: 4,
  }
end
