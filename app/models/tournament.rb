class Tournament < ApplicationRecord
  has_many :predefined_tournament_teams, dependent: :destroy
  has_many :predefined_teams, through: :predefined_tournament_teams
  has_many :teams, dependent: :destroy
  has_many :users, through: :teams
  has_many :tournament_players, through: :predefined_tournament_teams
  has_many :players, through: :tournament_players
  has_many :matches, dependent: :destroy
  has_many :tournament_coins, dependent: :destroy

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
      teams = scraper.get_teams(cricbuzz_tournament_url)
      predefined_tournament_teams = PredefinedTeam.add_teams(teams, self.id)
      squad = scraper.get_squads(cricbuzz_tournament_url)
      players_with_roles = scraper.get_player_role(squad)
      teams.each{ |team| Player.add_players(players_with_roles, predefined_tournament_teams) }
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

  def award_coins
    return unless tournament_coins.present? && teams.present? && !coins_awarded
    ActiveRecord::Base.transaction do
      teams.ordered_by_points.each_with_index do |team, standing|
        tournament_coins.each do |tournament_coin|
          if (tournament_coin.start_standing..tournament_coin.end_standing).include?(standing + 1)
            team.user.update(available_coins: (team.user.available_coins.to_i + tournament_coin.coins.to_i))
            break
          end
        end
      end
      update(coins_awarded: true)
    end
  end
end
