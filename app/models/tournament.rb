class Tournament < ApplicationRecord
  has_many :tournament_players
  has_many :palyers, through: :tournament_players
end
