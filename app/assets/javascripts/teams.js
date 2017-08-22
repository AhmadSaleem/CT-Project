document.addEventListener("turbolinks:load", function() {

  $('input[type=radio]').on('change', function() {
    $('input[type=radio]').not(this).prop('checked', false);
  });

});
