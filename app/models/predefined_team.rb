class PredefinedTeam < ApplicationRecord
  has_many :predefined_tournament_teams, dependent: :destroy
  has_many :tournaments, through: :predefined_tournament_teams
end
