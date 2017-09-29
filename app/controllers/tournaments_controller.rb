class TournamentsController < ApplicationController
  before_action :published_tournaments, only: [:index, :standings]
  def index
  end

  def show
    @tournaments = Tournament.find_by(id: params[:id])
  end

  def standings
  end

  def team_standings
    @tournament_teams = Tournament.find(params[:id]).teams.ordered_by_points
    respond_to do |format|
      format.json { render json: { tournament_teams: @tournament_teams } }
    end
  end

  private
    def published_tournaments
      @tournaments = Tournament.published
    end
end
