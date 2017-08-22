class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_players, only: [:edit, :update]
  before_action :authenticate_user!, except: [:index]

  MAX_NO_OF_PLAYERS = 11

  def index
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      redirect_to @team, notice: "Sccuesfully Created"
    else
      render :new
    end
  end

  def edit
    unless @team.team_players.exists?
      MAX_NO_OF_PLAYERS.times { @team.team_players.new }
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team
    else
      render :edit
    end
  end

  def destroy
    if @team.destroy
      redirect_to teams_path, notice: "Team has been removed "
    end
  end

  private

    def team_params
      params.require(:team).permit(:id, :tournament_id, :team_name, team_players_attributes: [:id ,:tournament_player_id, :captain])
    end

    def set_team
      @team = Team.find(params[:id])
    end

    def set_players
      @players = @team.tournament_players.map {|tp| ["#{tp.player_name}(#{tp.budget_points})",tp.id]}
    end
end
