class TeamSquadScraper
  attr_reader :series_teams
  attr_reader :team_squads

  BASE_URL = "http://www.cricbuzz.com"

  def initialize
    @series_teams = []
    @team_squads  = {}
  end

  def get_teams(url)
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//*[@class="list-group cb-list-group"]/a').each do |team|
      series_teams.push(squads_link: team['href'], team_name: team.css("h3").text)
    end
    series_teams
  end

  def get_squads(team)
    type = ""
    doc = Nokogiri::HTML(open(BASE_URL + "#{team[:squads_link]}"))
    doc.xpath('//*[@class="cb-col cb-col-67 cb-nws-lft-col"]/*').each_with_index do |player, index|
      if Player::ROLE_VALUES.key?(player.text)
        type = player.text
        next
      end
      array = []
      player.xpath('div/div').each { |txt| array << txt.text }

      next unless type.present?
      team_squads.merge!(index => {team_name: team[:team_name], profile_link: player['href'], player_name: array[0], style: array[1], type: type })
    end
    team_squads
  end
end
