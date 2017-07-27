class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string  :name , null: false
      t.integer :role, null: false
      t.string :country, null: false
      t.string  :batting_style, null: false
      t.string  :bowling_style,  null:false

      t.timestamps
    end
  end
end
