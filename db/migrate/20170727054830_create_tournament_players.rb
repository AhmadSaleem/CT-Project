class CreateTournamentPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :tournament_players do |t|
      t.belongs_to :tournament, index: true
      t.belongs_to :player, index: true
      t.integer    :budget_points, null: false
      t.string     :team_name, null: false


      t.timestamps
    end
  end
end
