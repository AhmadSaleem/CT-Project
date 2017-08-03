class CreateMatchPredefinedTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :match_predefined_teams do |t|
      t.belongs_to :predefined_tournament_team, index: true
      t.belongs_to :match, index: true

      t.timestamps
    end
  end
end
