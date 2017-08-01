class PredefinedTournamentTeam < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :players, through: :tournament_players

  belongs_to :tournament
  belongs_to :predefined_team

  accepts_nested_attributes_for :tournament_players, reject_if: :all_blank, allow_destroy: true

end
