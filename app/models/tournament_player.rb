class TournamentPlayer < ApplicationRecord
  belongs_to :tournament
  belongs_to :player
  validates :budget_points, numericality: { greater_than: 0 }, presence: true
  validates :team_name, presence: true
  validates :player, uniqueness: true
end
