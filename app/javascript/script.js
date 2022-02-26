let title = "javascriptが使えました";
alert(title);

/*global $*/
$(document).ready(function () {
  $('.jquery').on('click', function(){
    $(this).css('color','red');
  });
});