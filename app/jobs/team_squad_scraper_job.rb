class TeamSquadScraperJob < ApplicationJob
  queue_as :default

  def perform(tournament_id)
    tournament = Tournament.find_by(id: tournament_id)
    tournament.fetch_team_and_squads if tournament.present?
  end
end
