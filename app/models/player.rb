class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :predefined_tournament_teams, through: :tournament_players

  validates :name, :country, :role, :batting_style, :bowling_style, presence: true

  enum role: {
    batsman: 1,
    bowler: 2,
    wk: 3,
    all_rounder: 4,
  }
end
