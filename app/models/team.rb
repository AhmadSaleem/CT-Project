class Team < ApplicationRecord
  has_many :match_team_players, dependent: :destroy
  has_many :team_players, dependent: :destroy
  has_many :enrolled_players, through: :team_players

  belongs_to :user
  belongs_to :tournament

  delegate :tournament_players, :modifications_limit, :coins_required, to: :tournament
  delegate :budget, to: :tournament, prefix: true
  delegate :available_coins, to: :user, prefix: true

  validates :tournament, :user, :team_name, presence: true
  validates_associated :team_players
  validates :user, uniqueness: { scope: :tournament, message: "You can register only one team in a tournament" }
  validate :budget
  validate :coins
  validate :unique_players
  before_create :set_modifications_limit

  accepts_nested_attributes_for :team_players, reject_if: :all_blank, allow_destroy: true

  private

    def set_modifications_limit
      self.modifications_remaining = modifications_limit
    end

    def unique_players
      if team_players.pluck(:team_id, :tournament_player_id).uniq!
        errors.add(:torunament_player_id, ": Can not add duplicate players")
      end
    end

    def budget
      if tournament_budget < team_players.collect(&:enrolled_player).collect(&:budget_points).sum
        errors.add(:id,"Please choose players within the budget allowed ")
      end
    end

    def coins
      if user_available_coins < coins_required
        errors.add(:base, "You don't have enough coins")
      end
    end
end
