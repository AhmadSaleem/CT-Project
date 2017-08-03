class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.belongs_to :user, index: true
      t.belongs_to :tournament, index: true
      t.integer    :modifications_allowed, null: false
      t.string     :team_name, null: false
 t.timestamps
    end
  end
end
