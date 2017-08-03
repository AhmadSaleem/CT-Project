class CreateTeamPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :team_players do |t|
      t.belongs_to :team, index: true
      t.belongs_to :player, index: true
      t.timestamps
    end
  end
end
