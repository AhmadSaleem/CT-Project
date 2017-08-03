class TeamPlayer < ApplicationRecord
  belongs_to :team
  belongs_to :tournament_player
end
