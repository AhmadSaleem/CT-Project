class AddReferenceOfMatchPredefinedTeamToMatchPlayerPerformance < ActiveRecord::Migration[5.1]
  def change
    remove_column(:match_player_performances, :match_predefined_team_id, :integer )
    add_reference(:match_player_performances, :match_predefined_team, index: true )
  end
end
