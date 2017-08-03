class MatchPlayerPerformance < ApplicationRecord
  belongs_to :match
  belongs_to :tournament_player

  validates :runs, :balls, :fours, :sixes, presence: true
end
