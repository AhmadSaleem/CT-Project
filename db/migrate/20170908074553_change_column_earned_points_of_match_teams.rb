class ChangeColumnEarnedPointsOfMatchTeams < ActiveRecord::Migration[5.1]
  def up
    change_column :match_teams, :points_earned, :integer, default: 0
  end

  def down
    change_column :match_teams, :points_earned, :integer, default: nil
  end
end
