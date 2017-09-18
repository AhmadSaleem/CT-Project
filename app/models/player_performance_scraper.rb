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
      reset_fielding_performance
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
          record = row.css('div').map(&:text)
          break if record.include?("Extras")

          create_fielding_performance(record[1], inning_no, bowling_team(inning_no))
          player_match_inning = set_player_match_inning(record, inning_no, team_name)
          wicket_keeper = wicket_keeper?(record[0])
          record.map! { |col| col.gsub(/\W/, ' ').strip if col.gsub(/\W/, ' ').strip.present? }.compact!
          batting_performance = set_batting_performance(record)
          save_performance(player_match_inning, batting_performance.merge(wicket_keeper: wicket_keeper))
        rescue => e
          ExceptionMailer.exception_mail(e.message).deliver_later
        end
      end
    end

    def create_bowling_performance(inning, inning_no, team_name)
      inning.xpath(XPATH_OF_BOWLING).each do |row|
        begin
          record = row.css('div').map(&:text)
          player_match_inning = set_player_match_inning(record, inning_no, team_name)
          bowling_performance = set_bowling_performance(record)
          save_performance(player_match_inning, bowling_performance)
        rescue => e
          ExceptionMailer.exception_mail(e.message).deliver_later
        end
      end
    end

    def create_fielding_performance(wicket_detail, inning_no, team_name)
      begin
        catcher_with_cb = wicket_detail.scan(/c [A-z]+\s*[A-z]* b/).first
        wk_with_st_b = wicket_detail.scan(/st [A-z]+\s*[A-z]* b/).first
        if catcher_with_cb.present?
          player_name = catcher_with_cb.gsub(/c|b/,'').strip
          save_performance(set_player_match_inning(player_name, inning_no, team_name), {catches: 1}, true)
        elsif wicket_detail.include?("run out")
          wicket_detail.scan(/\([^()]*\)/).first.gsub(/[()]/, "").split('/').each do |player_name|
            save_performance(set_player_match_inning(player_name, inning_no, team_name), {run_outs: 1}, true)
          end
        elsif wk_with_st_b.present?
          player_name = wk_with_st_b.gsub(/st|b/,'').strip
          save_performance(set_player_match_inning(player_name, inning_no, team_name), {stumpings: 1}, true)
        end
      rescue => e
        ExceptionMailer.exception_mail(e.message).deliver_later
      end
    end

    def set_batting_performance(record)
      {
        wicket_detail: record[1],
        runs: record[2].to_i,
        balls: record[3].to_i,
        fours: record[4].to_i,
        sixes: record[5].to_i,
        strike_rate: record[6].to_f
      }
    end

    def set_bowling_performance(record)
      {
        overs: record[1],
        maiden_overs: record[2],
        runs_conceded: record[3],
        wickets: record[4],
        no_balls: record[5],
        wide_balls: record[6],
        economy: record[7]
      }
    end

    def set_player_match_inning(name, inning_no, team_name)
      tournament_player = TournamentPlayer.player_by_name(name[0].gsub(/\([^()]*\)/,'').strip) if name.is_a? Array
      tournament_player = TournamentPlayer.player_by_second_name(name) if name.is_a? String
      {
        tournament_player: tournament_player,
        match_predefined_team: match.predefined_team_by_name(team_name),
        inning: INNINGS[inning_no]
      }
    end

    def save_performance(player_match_inning, inning_performance, fielding_performance = false)
      player_performance = MatchPlayerPerformance.find_by(player_match_inning)
      return update_fielding_performance(player_performance, player_match_inning, inning_performance) if fielding_performance && player_performance.present?
      return player_performance.update(inning_performance) if player_performance.present?
      MatchPlayerPerformance.create(player_match_inning.merge(inning_performance))
    end

    def update_fielding_performance(player_performance, player_match_inning, inning_performance)
      player_performance.update(inning_performance.keys[0] => player_performance.send(inning_performance.keys[0]).next)
    end

    def reset_fielding_performance
      match.match_player_performances.update_all(catches: 0, run_outs: 0, stumpings: 0)
    end

    def wicket_keeper?(name)
      name.include?("(wk)") || name.include?("& wk)")
    end
end
