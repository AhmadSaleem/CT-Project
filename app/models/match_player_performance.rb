class MatchPlayerPerformance < ApplicationRecord
  belongs_to :tournament_player
  belongs_to :match_predefined_team

  validates :tournament_player, :match_predefined_team, presence: true
  validates :tournament_player, uniqueness: { scope: [:match_predefined_team, :inning], message: "can't add same player twice" }

  delegate :match, to: :match_predefined_team

  enum inning: {
    first_inning: 1,
    second_inning: 2,
  }
end
