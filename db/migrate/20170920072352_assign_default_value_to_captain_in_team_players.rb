class AssignDefaultValueToCaptainInTeamPlayers < ActiveRecord::Migration[5.1]
  def up
    change_column :team_players, :captain, :boolean, default: false
  end

  def down
    change_column :team_players, :captain, :boolean
  end
end
