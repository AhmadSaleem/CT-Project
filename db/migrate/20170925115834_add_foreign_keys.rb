class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    #foreign keys related to tournament
    add_foreign_key :tournament_coins, :tournaments, on_delete: :cascade
    add_foreign_key :matches, :tournaments, on_delete: :cascade
    add_foreign_key :teams, :tournaments, on_delete: :cascade
    add_foreign_key :predefined_tournament_teams, :tournaments, on_delete: :cascade

    #foreign keys related to matches
    add_foreign_key :match_teams, :matches, on_delete: :cascade
    add_foreign_key :match_predefined_teams, :matches, on_delete: :cascade

    #foreign keys related to teams
    add_foreign_key :match_teams, :teams, on_delete: :cascade
    add_foreign_key :team_players, :teams, on_delete: :cascade

    #foreign keys related to predefined_tournament_teams
    add_foreign_key :tournament_players, :predefined_tournament_teams, on_delete: :cascade
    add_foreign_key :match_predefined_teams, :predefined_tournament_teams, on_delete: :cascade

    #foreign keys related to match_predefined_teams
    add_foreign_key :match_player_performances, :match_predefined_teams, on_delete: :cascade

    #foreign keys related to tournament_players
    add_foreign_key :team_players, :tournament_players, on_delete: :cascade
    add_foreign_key :match_team_players, :tournament_players, on_delete: :cascade
    add_foreign_key :match_player_performances, :tournament_players, on_delete: :cascade

    #foreign keys related to players
    add_foreign_key :tournament_players, :players, on_delete: :cascade

    #foreign keys related to predefined_teams
    add_foreign_key :predefined_tournament_teams, :predefined_teams, on_delete: :cascade

    #foreign keys related to tournament_players
    add_foreign_key :social_logins, :users, on_delete: :cascade
    add_foreign_key :teams, :users, on_delete: :cascade

  end
end
