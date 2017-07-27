class CreateTournaments < ActiveRecord::Migration[5.1]
  def change
    create_table :tournaments do |t|
      t.string  :title, null: false
      t.string  :format,  null: false
      t.integer :modifications_limit, null: false
      t.integer :coins_required, null: false
      t.integer :budget, null: false

      t.timestamps
    end
  end
end
