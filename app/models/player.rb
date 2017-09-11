class Player < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :predefined_tournament_teams, through: :tournament_players

  validates :name, :role, :batting_style, :bowling_style, presence: true

  enum role: {
    batsman: 1,
    bowler: 2,
    wk: 3,
    all_rounder: 4,
  }

  ROLE_VALUES = { "Batsmen" => 1, "Bowlers" =>  2, "Wicket-Keepers" => 3, "All-Rounders" => 4 }

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
    players.each do |key, player|
      new_player = create_player(player)
      team = predefined_tournament_teams.map{ |team| team if team.team_name == player[:team_name] }.compact
      TournamentPlayer.where(player: new_player, predefined_tournament_team: team ).first_or_create!
    end
  end

  def self.create_player(player)
    Player.where(name: player[:player_name]).first_or_create! do |attributes|
      attributes.role = ROLE_VALUES[player[:type]]
      attributes.batting_style = player[:type] == "Batsmen" ? player[:style] : 'None'
      attributes.bowling_style = player[:type] == "Bowlers" ? player[:style] : 'None'
      attributes.batting_style = player[:type] == "Wicket-Keepers" ? player[:style] : 'None'
      if player[:type] == "All-Rounders"
        attributes.batting_style = player[:style].split(",")[0]
        player[:style].split(",")[1] == " " ? attributes.bowling_style = "None" : attributes.bowling_style = player[:style].split(",")[1]
      end
    end
  end
end
