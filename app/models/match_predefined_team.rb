class MatchPredefinedTeam < ApplicationRecord
  has_many :match_player_performances, dependent: :destroy
  has_many :tournament_players, through: :match_player_performances

  belongs_to :match
  belongs_to :predefined_tournament_team

  delegate :team_name, to: :predefined_tournament_team

  validates :predefined_tournament_team, presence: { message: "must exist" }, uniqueness: { scope: :match, message: 'teams should be diferent' }
  accepts_nested_attributes_for :match_player_performances, reject_if: :all_blank, allow_destroy: true
end
