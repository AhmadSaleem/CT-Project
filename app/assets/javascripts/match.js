
  $(document).ready(function (){

    set_teams();
    set_first_team_player();
    set_second_team_player();
  });

  function set_teams(){
    var tournament_teams = $('#team_1').html();
    if (tournament_teams != undefined) {
      var tournament = $('#match_tournament_id :selected').text();
      if(tournament != ""){
        $('#team_1').attr('disabled',false);
        $('#team_2').attr('disabled',false);
        $('#team_1').find("optgroup:not([label='" + tournament + "'])").remove();
        $('#team_2').find("optgroup:not([label='" + tournament + "'])").remove();
     }
    }
  }

  function set_first_team_player(){
    var players_list = $('.player_1').html();
    tournament= $('#match_tournament_id').val();
    team = $('#team_1').val();
    if (team != "" && tournament != null) {
      $('.player_1').attr('disabled', false);
      $('.player_1').find("[data-team-id !='"+ team +"']").remove();
      $('.player_1').find("[data-tournament-id !='"+ tournament +"']").remove();
    }
    else {
      $('a.button.has_many_add').attr('disabled', true)
    }
  };

  function set_second_team_player(){
    var players_list = $('.player_2').html();
    tournament= $('#match_tournament_id').val();
    team = $('#team_2').val();
    if (team != "" && tournament != null) {
      $('.player_2').attr('disabled', false);
      $('.player_2').find("[data-team-id !='"+ team +"']").remove();
      $('.player_2').find("[data-tournament-id !='"+ tournament +"']").remove();
    }
  }


  $(function() {
    var tournament_teams = $('#team_1').html();
    $("#match_tournament_id").on("change",function() {
      $('#team_1').attr('disabled',false);
      $('#team_2').attr('disabled',false);
      $('#team_1').html(tournament_teams);
      $('#team_2').html(tournament_teams);
      if (this.value != "") {
        var tournament = $('#match_tournament_id :selected').text();
        $('#team_1').find("optgroup:not([label='" + tournament + "'])").remove();
        $('#team_2').find("optgroup:not([label='" + tournament + "'])").remove();
      }
    });
  });



  $(function () {
    var players_list = $('.player_1').html();
    $(document).on('click', 'a.button.has_many_add', function(e) {
      var players_list = $('.player_1').html();
      tournament= $('#match_tournament_id').val();
      team = $('#team_1').val();
      if (team != "" && tournament != null) {
        $('.player_1').attr('disabled', false);
        $('.player_1').find("[data-team-id !='"+ team +"']").remove();
        $('.player_1').find("[data-tournament-id !='"+ tournament +"']").remove();
      }
    })
  });

  $(function() {

    $(document).on('click', 'a.button.has_many_add', function(e) {
      var players_list = $('.player_2').html();
      tournament= $('#match_tournament_id').val();
      team = $('#team_2').val();
      if (team != "" && tournament != null) {
        $('.player_2').attr('disabled', false);
        $('.player_2').find("[data-team-id !='"+ team +"']").remove();
        $('.player_2').find("[data-tournament-id !='"+ tournament +"']").remove();
      }
    })
  });

