class CalculateMatchPoints
  attr_reader :match
  attr_reader :performance
  attr_reader :points_summary

  def initialize(match)
    @match = match
    @points_summary = PointsSummary.send(match.format)
  end

  def call
    begin
      match.match_teams.each do |match_team|
        points_earned = 0
        fielding_dismissals_count = 0
        match_team.team_players.each do |player|
          player.match_player_performances.each do |performance|
            next unless performance.match == match
            @performance = performance
            points_earned += earned_points
            points_earned += points_earned if player.captain?
          end
        end
        match_team.update(points_earned: points_earned)
      end
    rescue => e
      ExceptionMailer.exception_mail(e.message).deliver_later
    end
  end

  private

    def earned_points
      begin
        points = batting_points + bowling_points + bonus_points + wk_points
      rescue => e
         ExceptionMailer.exception_mail(e.message).deliver_later
      end
    end

    def batting_points
      points = performance_points("runs") * summary_points("run")
      points += strike_rate_points(performance_points("strike_rate")) if batting_qualify?
      points += duck_points(performance_points("runs"), performance_points("balls")) || 0
    end

    def bowling_points
      points = performance_points("wickets") * summary_points("wicket")
      points += economy_points(performance_points("economy")) if bowling_qualify?
      points += performance_points("maiden_overs") * summary_points("maiden_over")
    end

    def bonus_points
      points = runs_milestone_points(performance_points("runs"))
      points += wicket_haul_points(performance_points("wickets")).to_i
      points += batting_status_points(performance_points("wicket_detail")).to_i
      points += performance_points("run_outs") * summary_points("run_out")
      points += performance_points("stumpings") * summary_points("stumping")
      points += performance_points("catches") * summary_points("catch_out")
      points += fielding_points(fielding_dismissals)
    end

    def wk_points
      return 0 unless performance.wicket_keeper?
      wk_dismissals = performance_points("catches") + performance_points("stumpings") + performance_points("run_outs")
      case wk_dismissals
        when 3
          points = summary_points("wk_dismissals_3")
        when 4..10
          points = points_summary("wk_dismissals_4_or_more")
        else
          return 0
      end
    end

    def fielding_dismissals
      return 0 if performance.wicket_keeper?
      performance_points("catches") + performance_points("run_outs")
    end

    def fielding_points(dismissals)
      case dismissals
        when 3
          points = summary_points("fielding_dismissals_3")
        when 4..10
          points = summary_points("fielding_dismissals_4plus")
        else
          return 0
      end
    end

    def strike_rate_points(strike_rate)
      case strike_rate
        when 250..Float::INFINITY
          points = summary_points("sr_250_or_more")
        when 200..249
          points = summary_points("sr_200_to_249")
        when 150..199
          points = summary_points("sr_150_to_199")
        when 125..149
          points = summary_points("sr_125_to_149")
        when 100..124
          points = summary_points("sr_100_to_124")
        when 80..99
          points = summary_points("sr_80_to_99")
        else
          points = summary_points("sr_0_to_79")
      end
    end


    def duck_points(runs, balls)
      return summary_points("diamond_duck") if runs == 0 && balls == 0
      return summary_points("golden_duck") if runs == 0 && balls == 1
      return summary_points("duck") if runs == 0 && balls > 1
    end

    def runs_milestone_points(runs)
      case runs
        when 30..49
          return summary_points("score_30_to_49")
        when 50..99
          return summary_points("score_50_to_99")
        when 100..149
          return summary_points("score_100_to_149")
        when 150..199
          return summary_points("score_150_to_199")
        when 200..249
          return summary_points("score_200_to_249")
        when 240..299
          return summary_points("score_250_to_299")
        when 300..349
          return summary_points("score_300_to_349")
        when 350..Float::INFINITY
          return summary_points("score_350_or_more")
        else
          return 0
        end
    end

    def batting_status_points(status)
      summary_points("not_out_or_retired_hurt") if status.eql?("not out") || status.eql?("retired hurt")
    end

    def wicket_haul_points(wickets)
      return summary_points("three_wickets") if wickets == 3
      return summary_points("four_wickets")  if wickets == 4
      return summary_points("five_wickets")  if wickets == 5
      return summary_points("six_wickets")   if wickets == 6
      summary_points("seven_wickets") if wickets >= 7
    end

    def economy_points(economy)
      case economy
        when 0..3
          return summary_points("rpo_3_or_Less")
        when 3..4
          return summary_points("rpo_3_to_4")
        when 4..5
          return summary_points("rpo_4_to_5")
        when 5..6
          return summary_points("rpo_5_to_6")
        when 6..7
          return summary_points("rpo_6_to_7")
        when 7..9
          return summary_points("rpo_7_to_9")
        when 9..10
          return summary_points("rpo_9_to_10")
        when 10..12
          return summary_points("rpo_10_to_12")
        when 12..14
          return summary_points("rpo_12_to_14")
        when 14..Float::INFINITY
          return summary_points("rpo_14_or_more")
        else
          return 0
      end
    end

    def batting_qualify?
      (match.format == 'T20' && performance_points("balls") >= 20 || performance_points("runs") >= 20) ||
      (match.format == 'ODI' && performance_points("balls") >= 25 || performance_points("runs") >= 25)
    end

    def bowling_qualify?
      (match.format == 'T20' && performance_points("overs") >= 2) || (match.format == 'ODI' && performance_points("overs") >= 3)
    end

    def summary_points(scoring_area)
      points_summary.send(scoring_area).take.points
    end

    def performance_points(scoring_area)
      performance.send(scoring_area) || 0
    end
end
