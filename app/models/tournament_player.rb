class TournamentPlayer < ApplicationRecord
  has_many :match_player_performances, dependent: :destroy
  has_many :matches, through: :match_player_performances
  has_many :team_players
  has_many :teams, through: :team_players
  has_many :match_team_players, dependent: :destroy

  has_one :captained_team, class_name: "MatchTeam", foreign_key: :captain_id


  belongs_to :predefined_tournament_team
  belongs_to :player

  validates :budget_points, numericality: { greater_than: 0 }, presence: true
  validates :predefined_tournament_team, :player, presence: true
  validates :player, uniqueness: { scope: :predefined_tournament_team }

  delegate :name, :role, to: :player, prefix: true
  delegate :tournament, to: :predefined_tournament_team

  def self.player_by_name(name)
    TournamentPlayer.joins(:player).where(players: {name: name}).first
  end

end
