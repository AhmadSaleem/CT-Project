class MatchTeam < ApplicationRecord
  has_many :match_team_players
  has_many :tournament_players, through: :match_team_players

  belongs_to :captain, class_name: "TournamentPlayer"
  belongs_to :match
  belongs_to :team

  validates :match, :team, :captain, presence: true

  delegate :team_players, :team_name, to: :team

  before_validation :set_captain, :set_remaining_modifications, on: :create
  after_create :add_match_team_players

  private
    def set_captain
      self.captain = team_players.captain.take.enrolled_player
    end

    def set_remaining_modifications
      self.modifications_remaining = team.modifications_remaining
    end

    def add_match_team_players
      team_players.each do |players|
        self.match_team_players.create(tournament_player_id: players.tournament_player_id)
      end
    end
end
