class PlayerPerformanceScraper
  attr_reader :match_url
  attr_reader :match
  attr_reader :batting_teams

  INNINGS = [:first_inning, :first_inning, :second_inning, :second_inning]

  XPATH_OF_BATTING = 'div/div[@class="cb-col cb-col-100 cb-scrd-itms"]'
  XPATH_OF_BOWLING = 'div[@class="cb-col cb-col-100 cb-ltst-wgt-hdr"][2]/div[@class="cb-col cb-col-100 cb-scrd-itms "]'
  XPATH_OF_TEAM    = 'div/div[@class="cb-col cb-col-100 cb-scrd-hdr-rw"]'
  XPATH_OF_INNING  = '//div[contains(@id,"inning")]'

  def initialize(match)
    @match = match
    @match_url = match.cricbuzz_match_url
    @batting_teams = []
  end

  def create_performance
    begin
      doc = Nokogiri::HTML(open(match_url))
      inning_team_name(doc)
      doc.xpath(XPATH_OF_INNING).each_with_index do |inning, inning_no|
        begin
          create_batting_performance(inning, inning_no, batting_teams[inning_no])
          create_bowling_performance(inning, inning_no, bowling_team(inning_no))
        rescue => e
          ExceptionMailer.exception_mail(e.message).deliver_later
        end
      end
    rescue => e
      ExceptionMailer.exception_mail(e.message).deliver_later
    end
  end

  private

    def bowling_team(inning_no)
      return batting_teams[1] if batting_teams[inning_no] == batting_teams[0]
      batting_teams[0]
    end

    def inning_team_name(doc)
      doc.xpath(XPATH_OF_INNING).each do |row|
        row.xpath(XPATH_OF_TEAM).each do |team_title|
          @batting_teams << row.css('span')[0].text.gsub(/(1st|2nd)? Innings/,'').strip
        end
      end
    end

    def create_batting_performance(inning, inning_no, team_name)
      inning.xpath(XPATH_OF_BATTING).each do |row|
        begin
          recode = row.css('div').map(&:text)
          break if recode.include?("Extras")
          player_match_inning = set_player_match_inning(recode, inning_no, team_name)
          batting_performance = set_batting_performance_of_seven_index(recode) if recode.length == 7
          batting_performance = set_batting_performance_of_eleven_index(recode) if recode.length == 11
          save_performance(player_match_inning, batting_performance)
        rescue => e
          ExceptionMailer.exception_mail(e.message).deliver_later
        end
      end
    end

    def create_bowling_performance(inning, inning_no, team_name)
      inning.xpath(XPATH_OF_BOWLING).each do |row|
        begin
          recode = row.css('div').map(&:text)
          player_match_inning = set_player_match_inning(recode, inning_no, team_name)
          bowling_performance = set_bowling_performance(recode)
          save_performance(player_match_inning, bowling_performance)
        rescue => e
          ExceptionMailer.exception_mail(e.message).deliver_later
        end
      end
    end

    def set_batting_performance_of_seven_index(recode)
      {
        wicket_detail: recode[1].strip,
        runs: recode[2].to_i,
        balls: recode[3].to_i,
        fours: recode[4].to_i,
        sixes: recode[5].to_i,
        strike_rate: recode[6].to_f
      }
    end

    def set_batting_performance_of_eleven_index(recode)
      {
        wicket_detail: recode[1].gsub(/\W/, ' ').strip,
        runs: recode[6].to_i,
        balls: recode[7].to_i,
        fours: recode[8].to_i,
        sixes: recode[9].to_i,
        strike_rate: recode[10].to_f
      }
    end

    def set_bowling_performance(recode)
      {
        overs: recode[1],
        maiden_overs: recode[2],
        runs: recode[3],
        wickets: recode[4],
        no_balls: recode[5],
        wide_balls: recode[6],
        economy: recode[7]
      }
    end

    def set_player_match_inning(recode, inning_no, team_name)
      {
        tournament_player: TournamentPlayer.player_by_name(recode[0].gsub(/\([^()]*\)/,'').strip),
        match_predefined_team: match.predefined_team_by_name(team_name),
        inning: INNINGS[inning_no]
      }
    end

    def save_performance(player_match_inning, inning_performance)
      player_performance = MatchPlayerPerformance.find_by(player_match_inning)
      return player_performance.update(inning_performance) if player_performance.present?
      MatchPlayerPerformance.create(player_match_inning.merge(inning_performance))
    end
end
