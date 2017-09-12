ActiveAdmin.register Tournament do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  action_item  :fetch_team_and_squads, only: [:show, :edit] do
    link_to 'Import Players ', fetch_team_and_squads_admin_tournament_path
  end

  action_item :publish_tournament, only: [:show, :edit] do
    unless resource.published?
      link_to 'Publish Tournament', publish_tournament_admin_tournament_path
    end
  end

  action_item :unpublish_tournament, only: [:show, :edit] do
    if resource.published?
      link_to 'Unpublish Tournament', unpublish_tournament_admin_tournament_path
    end
  end


  permit_params :cricbuzz_tournament_url, :title, :format, :modifications_limit, :coins_required, :budget,
  predefined_tournament_teams_attributes: [ :id, :predefined_team_id, :_destroy,
  tournament_players_attributes:[ :id, :player_id, :budget_points, :_destroy ] ]

  form do |f|
    f.inputs :title
    f.inputs :format
    f.inputs :modifications_limit
    f.inputs :coins_required
    f.inputs :budget
    f.inputs :cricbuzz_tournament_url
    f.inputs do
    f.has_many :predefined_tournament_teams do |a|
      a.input :predefined_team, as: :select, collection: PredefinedTeam.pluck(:team_name, :id)
        a.has_many :tournament_players do |b|
          b.input :player, as: :select, collection: Player.all
          b.input :budget_points
          b.input :_destroy, as: :boolean, label: :Remove_Player
        end
      a.input :_destroy, as: :boolean, label: :Remove_Team
    end
    end
    f.actions
  end

  show do
    panel "Tournament Teams" do
      tournament.predefined_tournament_teams.each do |predefined_team|
        panel predefined_team.team_name do
          render 'admin/tournaments/tournament_players', tournament_players: predefined_team.tournament_players
        end
      end
    end
    active_admin_comments
  end

  sidebar "Tournamnet Details", only: :show do
    attributes_table_for tournament do
      row :title
      row :format
      row :modifications_limit
      row :coins_required
      row :budget
    end
  end

  sidebar "Tournament Matches ", only: :show do
    attributes_table_for tournament.matches do
      row :id
      row :first_opponent
      row :second_opponent
      row :playing_date
    end
  end

  member_action :fetch_team_and_squads do
    TeamSquadScraperJob.perform_later(resource.id)
    flash[:notice] = "Importing teams and players..."
    redirect_to action: :show
  end

  member_action :publish_tournament do
    resource.publish_tournament
    redirect_to admin_tournaments_path, notice: "Successfully Published..."
  end

  member_action :unpublish_tournament do
    resource.unpublish_tournament
    redirect_to admin_tournaments_path, notice: "Successfully Unpublished..."
  end
end
