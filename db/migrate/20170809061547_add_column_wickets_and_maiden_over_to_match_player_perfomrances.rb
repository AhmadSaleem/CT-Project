class AddColumnWicketsAndMaidenOverToMatchPlayerPerfomrances < ActiveRecord::Migration[5.1]
  def change
    add_column(:match_player_performances, :wickets, :integer )
    add_column(:match_player_performances, :maiden_overs, :integer )
  end
end
