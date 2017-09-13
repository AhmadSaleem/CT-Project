class AddFieldsToMatchPlayerPerformances < ActiveRecord::Migration[5.1]
  def up
    add_column :match_player_performances, :strike_rate, :float, null: true
    add_column :match_player_performances, :wicket_detail, :string, null: true

    add_column :match_player_performances, :overs, :float, null: true
    add_column :match_player_performances, :economy, :float, null: true
    add_column :match_player_performances, :runs_conceded, :integer, null: true
    add_column :match_player_performances, :no_balls, :integer, null: true
    add_column :match_player_performances, :wide_balls, :integer, null: true
    add_column :match_player_performances, :inning, :integer

    change_column :match_player_performances, :runs, :integer, null: true
    change_column :match_player_performances, :balls, :integer, null: true
    change_column :match_player_performances, :fours, :integer, null: true
    change_column :match_player_performances, :sixes, :integer, null: true
    change_column :match_player_performances, :wickets, :integer, null: true
    change_column :match_player_performances, :maiden_overs, :integer, null: true

  end

  def down
    remove_column :match_player_performances, :strike_rate, :float, null: true
    remove_column :match_player_performances, :wicket_detail, :string, null: true

    remove_column :match_player_performances, :overs, :float, null: true
    remove_column :match_player_performances, :economy, :float, null: true
    remove_column :match_player_performances, :runs_conceded, :integer, null: true
    remove_column :match_player_performances, :no_balls, :integer, null: true
    remove_column :match_player_performances, :wide_balls, :integer, null: true
    remove_column :match_player_performances, :inning, :integer

    change_column :match_player_performances, :runs, :integer, null: false
    change_column :match_player_performances, :balls, :integer, null: false
    change_column :match_player_performances, :fours, :integer, null: false
    change_column :match_player_performances, :sixes, :integer, null: false
    change_column :match_player_performances, :wickets, :integer, null: true
    change_column :match_player_performances, :maiden_overs, :integer, null: true
  end

end
