class MatchPredefinedTeam < ApplicationRecord
  belongs_to :match
  belongs_to :predefined_tournament_team
end
