class MatchPlayerPerformance < ApplicationRecord
  belongs_to :tournament_player
  belongs_to :match_predefined_team

  validates :tournament_player, uniqueness: { scope: :match_predefined_team, message: "can't add same player twice" }
  validates :runs, :balls, :fours, :sixes, presence: true
end
