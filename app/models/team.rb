class Team < ApplicationRecord
  has_many :match_team_players, dependent: :destroy
  has_many :team_players, dependent: :destroy
  belongs_to :user
  belongs_to :tournament

  delegate :tournament_players, to: :tournament

  validates :tournament, :team_name, presence: true
  validates_associated :team_players
  validates :user, uniqueness: { scope: :tournament }
  validate :unique_players
  accepts_nested_attributes_for :team_players, reject_if: :all_blank, allow_destroy: true

  def unique_players
     if team_players.pluck(:team_id, :tournament_player_id).uniq!
       errors.add(:torunament_player_id, ": Can Not add Duplicate Players")
     end
  end
end
