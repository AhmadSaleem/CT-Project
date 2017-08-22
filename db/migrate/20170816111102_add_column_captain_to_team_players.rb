class AddColumnCaptainToTeamPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :team_players, :captain, :boolean
  end
end
