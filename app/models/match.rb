class Match < ApplicationRecord
  has_many :match_player_performances, dependent: :destroy
  has_many :tournament_players, through: :match_player_performances

  has_many :match_predefined_teams, dependent: :destroy
  has_many :predefined_tournament_teams, through: :match_predefined_teams
  has_many :match_team_players, dependent: :destroy

  belongs_to :tournament

  accepts_nested_attributes_for :match_player_performances, reject_if: :all_blank, allow_destroy: true

  validate :match_date_cannot_be_in_the_past
  validates :playing_date, :first_opponent, :second_opponent, presence: true

  private
    def match_date_cannot_be_in_the_past
      if playing_date < Date.today
        errors.add(:playing_date, "can't be in past")
      end
    end
end
