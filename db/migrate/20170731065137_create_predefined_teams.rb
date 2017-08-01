class CreatePredefinedTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :predefined_teams do |t|
      t.string :team_name, null: false

      t.timestamps
    end
  end
end
