class AddColumnWicketkeeperToMatchPlayerPerformance < ActiveRecord::Migration[5.1]
  def change
    add_column :match_player_performances, :wicket_keeper, :boolean, default: false
  end
end
