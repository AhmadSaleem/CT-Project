ActiveAdmin.register TournamentPlayer do
  menu false
  actions :edit, :update

  permit_params :predefined_tournament_team_id, :player_id, :budget_points

  controller do
    def edit
      session[:return_to] ||= request.referer
    end

    def update
      @tournament_player = TournamentPlayer.find(permitted_params[:id])
      if @tournament_player.update(permitted_params[:tournament_player])
        redirect_to session.delete(:return_to), notice: "Updated Successfully"
      else
        render :edit
      end
    end
  end

  form do |f|
    f.inputs "Edit Tournament Player" do
      f.input :player, as: :select
      f.input :budget_points
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(session[:return_to])
    end
  end
end

