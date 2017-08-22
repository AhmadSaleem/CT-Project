class RemovePlayerReferenceAddTournamentPlayerReferenceToMatchTeamPlayer < ActiveRecord::Migration[5.1]
  def change
    remove_column(:match_team_players, :player_id, :integer )
    add_reference(:match_team_players, :tournament_player, index: true )
  end
end
