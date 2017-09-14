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
  validate  :match_date_cannot_be_in_the_past, on: :create
  validate  :unique_teams
  scope :ordered, -> { order('playing_date ASC') }

  after_create :add_match_teams

  def predefined_team_by_name(name)
    match_predefined_teams.joins(predefined_tournament_team: :predefined_team)
                            .where(predefined_teams: {team_name: name}).first
  end

  def approve_match
    update(approved: true)
  end

  def disapprove_match
    update(approved: false)
  end

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

    def add_match_teams
      tournament.teams.each { |team| self.match_teams.create(team: team) }
    end

end
