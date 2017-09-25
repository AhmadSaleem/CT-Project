class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :standings]
  def index
    @tournaments = Tournament.published
  end

  def show
  end

  def standings
  end

  private
    def set_tournament
      @tournament = Tournament.find_by(id: params[:id])
    end
end
