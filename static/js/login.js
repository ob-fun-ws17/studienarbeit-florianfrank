$(window, document, undefined).ready(function() {

  $('input').blur(function() {
    var $this = $(this);
    if ($this.val())
      $this.addClass('used');
    else
      $this.removeClass('used');
  });

  var $ripples = $('.ripples');

  $ripples.on('click.Ripples', function(e) {

    var $this = $(this);
    var $offset = $this.parent().offset();
    var $circle = $this.find('.ripplesCircle');

    var x = e.pageX - $offset.left;
    var y = e.pageY - $offset.top;

    $circle.css({
      top: y + 'px',
      left: x + 'px'
    });

    $this.addClass('is-active');

  });

  $ripples.on('animationend webkitAnimationEnd mozAnimationEnd oanimationend MSAnimationEnd', function(e) {
  	$(this).removeClass('is-active');
  });

});

function login(){
    var mail = document.querySelector("#mail").value;
    var password = document.querySelector("#password").value;
    var obj = '{ "mail":"'+mail+'", "password":"'+password+'"}'
    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/login", true);
     xhttp.setRequestHeader("Content-type", "application/json");
     var sendAlert = true;
     xhttp.onreadystatechange = function() {
         if(sendAlert){
             var response = xhttp.responseText
             if(response){
                 sendAlert = false;
                 if (response.search("error") != -1){
                     alert("Login failed: "+response);
                 }else if(response.search("mail") != -1){
                     window.location.reload();
                     alert("You are sucessfully logged in with email: "+mail);
                 }
             }
           }
         }
     xhttp.send(obj);
}
