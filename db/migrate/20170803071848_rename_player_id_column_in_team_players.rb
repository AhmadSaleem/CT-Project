class RenamePlayerIdColumnInTeamPlayers < ActiveRecord::Migration[5.1]
  def change
    rename_column :team_players, :player_id, :tournament_player_id
  end
end
