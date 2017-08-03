class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.references :tournament, index: true
      t.datetime   :playing_date, null: false
      t.string     :opponent, null: false
      t.string     :opponent_1, null: false

      t.timestamps
    end
  end
end
