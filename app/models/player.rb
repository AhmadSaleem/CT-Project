class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :predefined_tournament_teams, through: :tournament_players

  validates :name, :role, :batting_style, :bowling_style, presence: true

  enum role: {
    batsman: 1,
    bowler: 2,
    wk: 3,
    all_rounder: 4,
  }

  enum country: {
    india:        1,
    south_africa: 2,
    england:      3,
    new_zealand:  4,
    australia:    5,
    pakistan:     6,
    sri_lanka:    7,
    west_indies:  8,
    bangladesh:   9,
    zimbabwe:     10,
    afghanistan:  11,
    ireland:      12,
  }
end
