$ ->
  $("#select-tournament").change ->
    tournament_id = $("#select-tournament option").filter(':selected').val()
    $.ajax "/tournaments/team_standings?id=#{tournament_id}",
      type:     'GET',
      datatype: 'json',
      success:  (tournament) ->
        table = ""
        for team in tournament.tournament_teams
          table += "<tr>
                      <td>#{team.team_name}</td>
                      <td>#{team.points_earned}</td>
                      <td>#{team.modifications_remaining}</td>
                    </tr>"
        $('#teams-table-body').html(table)
