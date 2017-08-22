class Match < ApplicationRecord

  has_many :match_predefined_teams, dependent: :destroy
  has_many :predefined_tournament_teams, through: :match_predefined_teams
  has_many :match_teams, dependent: :destroy
  has_many :teams, through: :match_teams
  has_many :match_player_performances, through: :match_predefined_teams
  has_many :tournament_players, through: :match_player_performances

  belongs_to :tournament

  accepts_nested_attributes_for :match_predefined_teams, reject_if: :all_blank, allow_destroy: true

  validates :playing_date, presence: true
  validates :match_predefined_teams, presence: true
  validate  :match_date_cannot_be_in_the_past
  validate  :unique_teams
  scope :ordered, -> { order('playing_date ASC') }

  private
    def match_date_cannot_be_in_the_past
      if playing_date.present? && playing_date < Date.today
        errors.add(:playing_date, "can't be in past")
      end
    end

    def unique_teams
      if match_predefined_teams.collect.map{ |m| [m.predefined_tournament_team_id] }.flatten.uniq!
        errors.add(:predefined_tournamnt_id, "can not add duplicte")
      end
    end
end
