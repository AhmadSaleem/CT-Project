class TournamentPlayer < ApplicationRecord
  belongs_to :predefined_tournament_team
  belongs_to :player

  validates :budget_points, numericality: { greater_than: 0 }, presence: true
  validates :predefined_tournament_team, :player, presence: true
  validates :player, uniqueness: true
end
