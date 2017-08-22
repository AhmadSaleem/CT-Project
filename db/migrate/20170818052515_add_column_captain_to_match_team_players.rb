class AddColumnCaptainToMatchTeamPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :match_team_players, :captain, :boolean
  end
end
