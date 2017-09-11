class PredefinedTeam < ApplicationRecord
  has_many :predefined_tournament_teams, dependent: :destroy
  has_many :tournaments, through: :predefined_tournament_teams

  def self.add_teams(teams_array, tournament_id)
    tournament = Tournament.find_by_id(tournament_id)
    return unless tournament.present?
    predefined_tournament_teams = []
    teams_array.each do |team|
      predefined_team = PredefinedTeam.where(team_name: team[:team_name]).first_or_create!
      predefined_tournament_teams << PredefinedTournamentTeam.where(tournament: tournament, predefined_team: predefined_team).first_or_create!
    end
    predefined_tournament_teams
  end
end
