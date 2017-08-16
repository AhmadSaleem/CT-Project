class TeamPlayer < ApplicationRecord
  belongs_to :enrolled_player, class_name: "TournamentPlayer", foreign_key: :tournament_player_id
  belongs_to :team

  validates :enrolled_player, uniqueness: { scope: :team }
  delegate :player_name, :budget_points, to: :enrolled_player

end
