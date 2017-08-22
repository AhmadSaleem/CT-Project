class AddMatchTeamReferenceToMatchTeamPlayers < ActiveRecord::Migration[5.1]
  def change
    add_reference :match_team_players, :match_team, index: true
    add_foreign_key :match_team_players, :match_teams, on_delete: :cascade
    remove_reference :match_team_players, :match
    remove_reference :match_team_players, :team
  end
end
