ActiveAdmin.register Match do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

permit_params :cricbuzz_match_url, :tournament_id, :playing_date,
                match_predefined_teams_attributes: [:id, :predefined_tournament_team_id,
                match_player_performances_attributes: [:id, :tournament_player_id, :runs,
                :balls, :sixes, :fours, :strike_rate, :overs, :no_balls, :wide_balls, :economy,
                :runs_conceded, :wickets, :maiden_overs, :inning, :_destroy]]

  form  do |f|
    f.object.errors.keys
    f.inputs :tournament
    f.inputs :playing_date
    f.inputs :cricbuzz_match_url
    f.inputs "Select teams" do
      (2 - f.object.match_predefined_teams.size).times do
        f.object.match_predefined_teams.build
      end
      id_index = 1
      f.fields_for :match_predefined_teams do |team|
        team.input :predefined_tournament_team, label: "Select Teams",
                                                collection: option_groups_from_collection_for_select(
                                                  Tournament.order(:title),
                                                  :predefined_tournament_teams,
                                                  :title,
                                                  :id,
                                                  :team_name,
                                                  team.object.predefined_tournament_team_id
                                                  ),
                                                include_blank: "Select Team",
                                                input_html: { id: "team_#{id_index}" }

        team.has_many :match_player_performances, new_record: 'Add Player Performance' do |player|
          player.input :tournament_player, label: "Select Player", as: :select,
                                           collection: TournamentPlayer.all.map { |tp|
                                              if tp.id == player.object.tournament_player_id
                                              "<option selected='selected' value=#{tp.id} data-tournament-id=#{tp.tournament.id}
                                                data-team-id=#{tp.predefined_tournament_team_id}>#{tp.player_name} </option>".html_safe
                                              else
                                                "<option value=#{tp.id} data-tournament-id=#{tp.tournament.id}
                                                data-team-id=#{tp.predefined_tournament_team_id}>#{tp.player_name} </option>".html_safe
                                              end
                                            },
                                            include_blank: "Select Player",
                                            input_html: { class: "player_#{id_index}" }

          player.input :inning
          player.input :runs, label: "Runs Scored"
          player.input :balls
          player.input :fours
          player.input :sixes
          player.input :wickets
          player.input :strike_rate
          player.input :overs
          player.input :runs_conceded
          player.input :no_balls
          player.input :wide_balls
          player.input :economy
          player.input :maiden_overs
          player.input :_destroy, as: :boolean, label: "Remove Player"
        end
      id_index = id_index.next
      end
    end
    f.actions
  end

  show do
    panel "Teams of Tournament" do
      columns {"Team Name"}
      match.match_predefined_teams.each do |team|
        columns do
          column { span team.predefined_tournament_team.team_name }
        end
        panel "Player Performances" do
          panel "First Inning" do

            columns  do
              column { span :name }
              column { span :runs }
              column { span :balls }
              column { span :sixes }
              column { span :fours }
              column { span :strike_rate }
              column { span :overs }
              column { span :wickets }
              column { span :maiden_overs }
              column { span :runs_conceded }
              column { span :no_balls }
              column { span :wide_balls }
              column { span :economy }
              column { span :catches }
              column { span :run_outs }
              column { span :stumpings }
            end

            team.match_player_performances.first_inning.each do |performance|
              columns do
                column { span performance.tournament_player.player_name }
                column { span performance.runs  || "-" }
                column { span performance.balls || "-" }
                column { span performance.sixes || "-" }
                column { span performance.fours || "-" }
                column { span performance.strike_rate || "-" }
                column { span performance.overs || "-" }
                column { span performance.wickets || "-" }
                column { span performance.maiden_overs || "-" }
                column { span performance.runs_conceded || "-" }
                column { span performance.no_balls || "-" }
                column { span performance.wide_balls || "-" }
                column { span performance.economy || "-" }
                column { span performance.catches || "-" }
                column { span performance.run_outs || "-" }
                column { span performance.stumpings || "-" }
              end
            end
          end

          panel "Second Inning" do

            columns  do
              column { span :name }
              column { span :runs }
              column { span :balls }
              column { span :sixes }
              column { span :fours }
              column { span :strike_rate }
              column { span :overs }
              column { span :wickets }
              column { span :maiden_overs }
              column { span :runs_conceded }
              column { span :no_balls }
              column { span :wide_balls }
              column { span :economy }
              column { span :catches }
              column { span :run_outs }
              column { span :stumpings }
            end

            team.match_player_performances.second_inning.each do |performance|
              columns do
                column { span performance.tournament_player.player_name }
                column { span performance.runs  || "-" }
                column { span performance.balls || "-" }
                column { span performance.sixes || "-" }
                column { span performance.fours || "-" }
                column { span performance.strike_rate || "-" }
                column { span performance.overs || "-" }
                column { span performance.wickets || "-" }
                column { span performance.maiden_overs || "-" }
                column { span performance.runs_conceded || "-" }
                column { span performance.no_balls || "-" }
                column { span performance.wide_balls || "-" }
                column { span performance.economy || "-" }
                column { span performance.catches || "-" }
                column { span performance.run_outs || "-" }
                column { span performance.stumpings || "-" }
              end
            end
          end if team.match_player_performances.second_inning.present?

        end
      end
    end

    active_admin_comments
  end

  action_item :import_player_performances, only: [:show, :edit] do
    link_to 'Import Performance', import_player_performances_admin_match_path
  end

  action_item :approve_match, only: [:show, :edit] do
    link_to 'Approve Match', approve_match_admin_match_path unless resource.approved?
  end

  action_item :disapprove_match, only: [:show, :edit] do
    link_to 'Disapprove Match', disapprove_match_admin_match_path if resource.approved?
  end

  action_item :calculate_points, only: [:show, :edit] do
    link_to 'Calculate Points', calculate_points_admin_match_path if resource.approved?
  end

  member_action :import_player_performances do
    if resource.cricbuzz_match_url.present?
      PlayerPerformanceScraperJob.perform_later(resource.id)
      redirect_to admin_match_path, notice: "Importing Performance..."
    else
      redirect_to edit_admin_match_path, alert: "Please provide cricbuzz_match_url first"
    end
  end

  member_action :approve_match do
    if resource.approve_match
      redirect_to admin_match_path, notice: "Successfully Approved."
    else
      redirect_to admin_match_path, alert: resource.errors
    end
  end

  member_action :disapprove_match do
    if resource.disapprove_match
      redirect_to admin_match_path, notice: "Successfully disapproved."
    else
      redirect_to admin_match_path, notice: resource.errors
    end
  end

  member_action :calculate_points do
    CalculateMatchPointsJob.perform_later(resource.id)
    redirect_to admin_match_path, notice: "Calculating team points..."
  end

end
