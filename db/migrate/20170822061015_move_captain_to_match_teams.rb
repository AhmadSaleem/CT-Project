class MoveCaptainToMatchTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :match_teams, :captain_id, :integer, index: true
    add_foreign_key :match_teams, :tournament_players, column: :captain_id, on_delete: :cascade
    remove_column :match_team_players, :captain, :integer
  end
end
