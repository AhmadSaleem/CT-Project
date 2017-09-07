$ ->
  tournament_teams = $('#team_1').html()
  set_teams(tournament_teams)
  $('#match_tournament_id').on 'change', ->
    set_teams(tournament_teams)

set_teams = (tournament_teams) ->
  if (tournament_teams?)
    tournament = $('#match_tournament_id :selected').text();
    if tournament is ""
      $('#team_1').attr('disabled', true)
      $('#team_2').attr('disabled', true)
    else
      $('#team_1').html(tournament_teams)
      $('#team_2').html(tournament_teams)
      $('#team_1').attr('disabled', false)
      $('#team_2').attr('disabled', false)
      $('#team_1').find("optgroup:not([label='" + tournament + "'])").remove()
      $('#team_2').find("optgroup:not([label='" + tournament + "'])").remove()
