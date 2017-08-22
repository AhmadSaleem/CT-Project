class CreateMatchTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :match_teams do |t|
      t.integer    :modifications_remaining, null: false
      t.integer    :points_earned,           null: false
      t.belongs_to :team,                    index: true
      t.belongs_to :match,                   index: true

      t.timestamps
    end
  end
end
