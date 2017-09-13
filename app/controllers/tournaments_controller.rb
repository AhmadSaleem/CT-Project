class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.published
  end
end
