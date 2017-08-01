ActiveAdmin.register Tournament do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :title, :format, :modifications_limit, :coins_required, :budget,
  predefined_tournament_teams_attributes: [ :id, :predefined_team_id, :_destroy,
  tournament_players_attributes:[ :id, :player_id, :budget_points, :_destroy ] ]

  form do |f|
    f.inputs :title
    f.inputs :format
    f.inputs :modifications_limit
    f.inputs :coins_required
    f.inputs :budget
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
    panel "Teams of Tournament" do
      table_for tournament.predefined_teams do
        column 'Tournament Teams', :team_name
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

end
