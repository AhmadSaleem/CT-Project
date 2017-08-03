class RemovePlayerReferenceFromMatchPlayerPerformances < ActiveRecord::Migration[5.1]
  def change
    remove_reference(:match_player_performances, :player, index: true )
    add_reference(:match_player_performances, :tournament_player, index: true )
  end
end
