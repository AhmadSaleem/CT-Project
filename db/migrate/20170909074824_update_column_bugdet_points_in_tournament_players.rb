class UpdateColumnBugdetPointsInTournamentPlayers < ActiveRecord::Migration[5.1]
  def up
    change_column :tournament_players, :budget_points, :integer, default: 7
  end

  def down
    change_column :tournament_players, :budget_points, :integer, null: false
  end
end
