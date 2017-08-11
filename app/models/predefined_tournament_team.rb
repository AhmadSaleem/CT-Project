class PredefinedTournamentTeam < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :players, through: :tournament_players

  has_many :match_predefined_teams, dependent: :destroy
  has_many :matches, through: :match_predefined_teams

  belongs_to :tournament
  belongs_to :predefined_team

  accepts_nested_attributes_for :tournament_players, reject_if: :all_blank, allow_destroy: true

  validates :predefined_team, uniqueness: { scope: :tournament }

  delegate :team_name, to: :predefined_team
  delegate :team_id,   to: :predefined_team
end
