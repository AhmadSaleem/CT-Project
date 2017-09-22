class CreateTournamentCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :tournament_coins do |t|
      t.belongs_to :tournament,     index: true
      t.integer    :coins,          null: false
      t.integer    :start_standing, null: false
      t.integer    :end_standing,   null: false
      t.timestamps
    end
  end
end
