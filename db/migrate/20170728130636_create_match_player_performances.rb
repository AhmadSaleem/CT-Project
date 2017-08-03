class CreateMatchPlayerPerformances < ActiveRecord::Migration[5.1]
  def change
    create_table :match_player_performances do |t|
      t.belongs_to :match, index: true
      t.belongs_to :player, index: true
      t.integer    :runs, null: false
      t.integer    :balls, null: false
      t.integer    :fours, null: false
      t.integer    :sixes, null: false

      t.timestamps
    end
  end
end
