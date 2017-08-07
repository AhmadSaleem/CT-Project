class TeamPlayer < ApplicationRecord
  belongs_to :team
  belongs_to :tournament_player
  validates :tournament_player, uniqueness: { scope: :team }

  delegate :player_name, :budget_points, to: :tournament_player
end
