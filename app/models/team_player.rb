class TeamPlayer < ApplicationRecord
  belongs_to :enrolled_player, class_name: "TournamentPlayer", foreign_key: :tournament_player_id
  belongs_to :team

  validates :enrolled_player, uniqueness: { scope: :team, message: "Can not add duplicate players" }

  delegate :player_name, :budget_points, to: :enrolled_player

  scope :captain, -> { where(captain: true) }

  def name
    captain? ? player_name + "(c)" : player_name
  end
end
