class RemoveCoulmnTeamNameFromTournamentPlayer < ActiveRecord::Migration[5.1]
  def up
    remove_column :tournament_players, :team_name, :string
  end

  def down
    add_column :tournament_players, :team_name, :string
  end
end
