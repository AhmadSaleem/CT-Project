ActiveAdmin.register Tournament do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :title, :format, :modifications_limit, :coins_required, :budget,
  tournament_players_attributes: [:id, :player_id, :budget_points, :team_name, :_destroy]

  form do |f|
    f.inputs :title
    f.inputs :format
    f.inputs :modifications_limit
    f.inputs :coins_required
    f.inputs :budget
    f.inputs do
    f.has_many :tournament_players do |a|
      a.input :player, as: :select, collection: Player.all
      a.input :budget_points
      a.input :team_name
      a.input :_destroy, as: :boolean, label: :Remove_Player
    end
    end
    f.actions
  end

  show do
    panel "Players of Tournament" do
      table_for tournament.tournament_players do
        column  :player
        column  :budget_points
        column  :team_name
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
end
