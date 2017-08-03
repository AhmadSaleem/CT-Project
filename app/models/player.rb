class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :predefined_tournament_teams, through: :tournament_players

  has_many :match_player_performances, dependent: :destroy
  has_many :matches, through: :match_player_performances
  has_many :match_team_players, dependent: :destroy

  #accepts_nested_attributes_for :tournaments, reject_if:  :all_blank, allow_destroy: true

  validates :name, :country, :role, :batting_style, :bowling_style, presence: true

  enum role: {
    batsman: 1,
    bowler: 2,
    wk: 3,
    all_rounder: 4,
  }
end
