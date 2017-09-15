class AddFieldingColumnsToMatchPlayerPerformance < ActiveRecord::Migration[5.1]
  def change
    add_column :match_player_performances, :catches, :integer, default: 0
    add_column :match_player_performances, :run_outs, :integer, default: 0
    add_column :match_player_performances, :stumpings, :integer, default: 0
  end
end
