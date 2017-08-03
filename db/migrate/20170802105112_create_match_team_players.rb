class CreateMatchTeamPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :match_team_players do |t|
      t.belongs_to :team, index: true
      t.belongs_to :match, index: true
      t.belongs_to :player, index: true

      t.timestamps
    end
  end
end
