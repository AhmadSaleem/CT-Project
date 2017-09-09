ActiveAdmin.register Match do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

permit_params :cricbuzz_match_url, :tournament_id, :playing_date, match_predefined_teams_attributes: [:id, :predefined_tournament_team_id,
  match_player_performances_attributes: [:id, :tournament_player_id, :runs, :balls, :sixes, :fours, :wickets, :maiden_overs, :_destroy]]

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
                                               selected: team.object.predefined_tournament_team_id
                                               ),input_html: { id: "team_#{id_index}", disabled: true }
        #team.has_many :match_player_performances, new_record: 'Players Perfromance' do |player|
          #player.input :tournament_player, label: "Select Player", as: :select,
                                            #collection: TournamentPlayer.all.map { |tp|
                                              #if tp.id == player.object.tournament_player_id
                                              #"<option selected='selected' value=#{tp.id} data-tournament-id=#{tp.tournament.id}
                                                #data-team-id=#{tp.predefined_tournament_team_id}>#{tp.player_name} </option>".html_safe
                                              #else
                                                #"<option value=#{tp.id} data-tournament-id=#{tp.tournament.id}
                                                #data-team-id=#{tp.predefined_tournament_team_id}>#{tp.player_name} </option>".html_safe
                                              #end
                                            #},input_html: { class: "player_#{id_index}", disabled: true }
          #player.input :runs, label: "Runs Scored"
          #player.input :balls
          #player.input :fours
          #player.input :sixes
          #player.input :wickets
          #player.input :maiden_overs
          #player.input :_destroy, as: :boolean, label: "Remove Player"
        #end
      id_index = id_index.next
      end
    end
    f.actions
  end

  show do
    panel "Teams of Tournament" do
      table_for match.predefined_tournament_teams do
        column 'Teams Name', :team_name
      end
    end
    active_admin_comments
  end
end
