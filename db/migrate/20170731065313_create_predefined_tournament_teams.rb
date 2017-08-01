class CreatePredefinedTournamentTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :predefined_tournament_teams do |t|
      t.belongs_to :tournament, index: true
      t.belongs_to :predefined_team, index: true

      t.timestamps
    end
  end
end
