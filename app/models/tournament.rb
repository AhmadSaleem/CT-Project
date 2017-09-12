class Tournament < ApplicationRecord
  has_many :predefined_tournament_teams, dependent: :destroy
  has_many :predefined_teams, through: :predefined_tournament_teams
  has_many :teams, dependent: :destroy
  has_many :users, through: :teams
  has_many :tournament_players, through: :predefined_tournament_teams
  has_many :players, through: :tournament_players
  has_many :matches, dependent: :destroy

  accepts_nested_attributes_for :predefined_tournament_teams, reject_if: :all_blank, allow_destroy: true

  validates :title, :format, presence: true
  validates :coins_required, :budget, :modifications_limit,
    numericality: { greater_than: 0 }, presence: true

  scope :published, -> {where(published: true)}

  enum format: {
    T20: 1,
    ODI: 2,
    Test: 3,
  }

  def fetch_team_and_squads
    begin
      scraper = TeamSquadScraper.new
      teams = scraper.get_teams(self.cricbuzz_tournament_url)
      predefined_tournament_teams = PredefinedTeam.add_teams(teams, self.id)
      teams.each{ |team| Player.add_players(scraper.get_squads(team), predefined_tournament_teams) }
    rescue => e
      ExceptionMailer.exception_mail(e.message).deliver_later
    end
  end

  def publish_tournament
    update(published: true)
  end

  def unpublish_tournament
    update(published: false)
  end
end
