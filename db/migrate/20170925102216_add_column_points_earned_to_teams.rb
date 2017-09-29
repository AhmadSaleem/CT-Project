class AddColumnPointsEarnedToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :points_earned, :integer, default: 0
  end
end
