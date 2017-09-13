class Team < ApplicationRecord
  has_many :team_players, dependent: :destroy
  has_many :enrolled_players, through: :team_players
  has_many :match_teams, dependent: :destroy
  has_many :matches, through: :match_teams

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
  validate :team_balance

  CAPTAIN_MODIFICATION_PENALTY = 2

  before_create :set_modifications_limit
  before_update :update_captains
  before_update :update_modifications
  after_create  :deduct_coins

  scope :by_user, ->(user) {where(user: user)}

  accepts_nested_attributes_for :team_players, reject_if: :all_blank, allow_destroy: true

  private

    def team_balance
      roles = players_role
      errors.add(:Team," must contain at least 3 bowlers") if roles.count("bowler") < 3
      errors.add(:Team," must contain at least 3 batsmen") if roles.count("batsman") < 3
      errors.add(:Team," must contain at least 1 wicket keeper") if roles.count("wk") < 1
    end

    def player_roles
      team_players.flat_map(&:enrolled_player).flat_map(&:player).pluck(:role)
    end

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

    def update_captains
      team_players.captain.update_all(captain: false)
    end

    def update_modifications
      return if match_teams.blank?
      last_match_team = match_teams.find_by(match: matches.ordered.last)
      changes = (last_match_team.match_team_players.pluck(:tournament_player_id) - team_players.pluck(:tournament_player_id)).size
      self.modifications_remaining = last_match_team.modifications_remaining - changes

      updated_captain = team_players.map { |tp| tp.enrolled_player if tp.captain? && !(TeamPlayer.find(tp.id).captain?)}.compact
      self.modifications_remaining = modifications_remaining - CAPTAIN_MODIFICATION_PENALTY if last_match_team.captain != updated_captain
    end

    def deduct_coins
      coins = user_available_coins - coins_required
      user.update(available_coins: coins)
    end
end
