class AddColumnMatchPredefinedTeamsAndRemoveColumnMatchId < ActiveRecord::Migration[5.1]
  def change
    remove_reference(:match_player_performances, :match, index: true )
    add_column :match_player_performances, :match_predefined_team_id, :integer, null: false ,index: true
  end
end
