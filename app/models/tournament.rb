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
    return message = "Already awarded" if coins_awarded?
    @tournament_coins = tournament_coins
    return messgae = "Please first add tournament coins" unless @tournament_coins.present?
    @teams =  standings
    return message = "No teams to award coins" if @teams.empty?
    @teams.each_with_index do |team, standing|
      @tournament_coins.each do |tournament_coin|
        if (tournament_coin.start_standing - 1..tournament_coin.end_standing - 1).include?(standing)
          @user = Team.find_by(team_name: team[:team_name]).user
          updated_coins = @user.available_coins + tournament_coin.coins
          @user.update(available_coins: updated_coins)
          break
        end
      end
    end
    update(coins_awarded: true)
    message = "Successfully awarded coins"
  end

  def standings
    teams_standing = []
    teams.each_with_index do |team, index|
      sum = 0
      team.match_teams.each do |match_team|
        sum += match_team.points_earned
      end
      teams_standing.push(team_name: team.team_name, total: sum)
    end
    teams_standing.sort_by{|key, value| value}
  end
end
