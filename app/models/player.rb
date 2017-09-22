class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :predefined_tournament_teams, through: :tournament_players

  validates :name, presence: true

  enum role: {
    batsman: 1,
    bowler: 2,
    wk: 3,
    all_rounder: 4,
  }

  ROLE_VALUES = { "Batsman" => 1, "Bowler" =>  2, "WK-Batsman" => 3, "Batting Allrounder" => 4, "Bowling Allrounder" => 4 }

  enum country: {
    india:        1,
    south_africa: 2,
    england:      3,
    new_zealand:  4,
    australia:    5,
    pakistan:     6,
    sri_lanka:    7,
    west_indies:  8,
    bangladesh:   9,
    zimbabwe:     10,
    afghanistan:  11,
    ireland:      12,
  }

  def self.add_players(players, predefined_tournament_teams)
    players.each do |player|
      new_player = create_player(player)
      team = predefined_tournament_teams.map{ |team| team if team.team_name == player[:team_name] }.compact
      TournamentPlayer.where(player: new_player, predefined_tournament_team: team ).first_or_create!
    end
  end

  def self.create_player(player)
    Player.where(name: player[:name]).first_or_create! do |attributes|
      attributes.role =  ROLE_VALUES[player[:role]]
      attributes.batting_style = player[:batting_style]
      attributes.bowling_style = player[:bowling_style]
    end
  end
end
