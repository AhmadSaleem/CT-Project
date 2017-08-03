class Team < ApplicationRecord
  has_many :match_team_players, dependent: :destroy
  has_many :team_players, dependent: :destroy
  belongs_to :user
  belongs_to :tournament

  validates :tournament, presence: true

  accepts_nested_attributes_for :team_players, reject_if: :all_blank, allow_destroy: true
end
