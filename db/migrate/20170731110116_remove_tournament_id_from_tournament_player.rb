class RemoveTournamentIdFromTournamentPlayer < ActiveRecord::Migration[5.1]
  def change
    remove_reference( :tournament_players, :tournament, index: true )
    add_reference( :tournament_players, :predefined_tournament_team, index: true )
  end
end
