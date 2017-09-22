class TeamSquadScraper
  attr_reader :series_teams
  attr_reader :team_squads
  attr_reader :player_roles
  BASE_URL = "http://www.cricbuzz.com"

  def initialize
    @series_teams = []
    @team_squads  = []
    @player_roles = []
  end

  def get_teams(url)
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//*[@class="list-group cb-list-group"]/a').each do |team|
      series_teams.push(squads_link: team['href'], team_name: team.css("h3").text)
    end
    series_teams
  end

  def get_squads(url)
    team_name = ""
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//*[@class="list-group cb-list-group"]/*').each do |node|
      if node.css(".cb-srs-sqd-sb-hdr").present?
        team_name = node.text
      else
        node.xpath('div[@class="cb-col-67 cb-col"]/a').each do |player|
          team_squads.push(team_name: team_name, profile_link: player['href'], player_name: player.text )
        end
      end
    end
    team_squads
  end

  def get_player_role(players)
    players.each do |player|
      role = batting = bowling = nil
      doc = Nokogiri::HTML(open(BASE_URL + "#{player[:profile_link]}"))
      doc.xpath('//*[@class="cb-hm-rght"]/*').each do |attributes|
        value = attributes.next_element.text.strip
        role =  value if attributes.text == "Role"
        batting = value if attributes.text == "Batting Style"
        bowling = value if attributes.text == "Bowling Style"
        break if attributes.text == "ICC Rankings"
      end
      player_roles.push(team_name: player[:team_name], name: player[:player_name].gsub(/\([^()]*\)/,'').strip, role: role, batting_style: batting, bowling_style: bowling )
    end
    player_roles
  end
end
