class MatchTeamPlayer < ApplicationRecord
  belongs_to :tournament_player
  belongs_to :match_team
end
