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

function addMember()
{
    var name = document.querySelector("#name").value;
    var surname = document.querySelector("#surname").value;

    //Birthday
    var datepickerBirthD = document.querySelector("#datepickerBirthD").value;
    var datepickerExamation = document.querySelector("#datepickerExamation").value;

    var monthBirthD     = datepickerBirthD.substr(0, datepickerBirthD.search("/"));
    var dayBirthD   = datepickerBirthD.substr(datepickerBirthD.search("/")+1,datepickerBirthD.length-8);
    var yearBirthD    = datepickerBirthD.substr(datepickerBirthD.lastIndexOf("/")+1,datepickerBirthD.length);

    var monthExamation    = datepickerExamation.substr(0, datepickerExamation.search("/"));
    var dayExamation   = datepickerExamation.substr(datepickerExamation.search("/")+1,datepickerExamation.length-8);
    var yearExamation    = datepickerExamation.substr(datepickerExamation.lastIndexOf("/")+1,datepickerExamation.length);

    if  (monthExamation[0] == 0)
        monthExamation = monthExamation[1];

    if  (dayExamation[0] == 0)
        dayExamation = dayExamation[1];

    if  (monthBirthD[0] == 0)
        monthBirthD = monthBirthD[1];

    if  (dayBirthD[0] == 0)
        dayBirthD = dayBirthD[1];

    var obj = '{"name":"'+name+'", "surName":"'+surname+
                '", "birthDay":'+dayBirthD+
                ', "birthMonth":'+monthBirthD+
                ', "birthYear":'+yearBirthD+
                ', "examationDay":'+dayExamation+
                ', "examationMonth":'+monthExamation+
                ', "examationYear":'+yearExamation+
                ', "nextExamationAppointment":'+0+
                ', "instructionCheck":'+0+
                ', "exerciseCheck":'+0+'}';
    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/addMember", true);
     xhttp.setRequestHeader("Content-type", "application/json");
     var sendAlert = true;
     xhttp.onreadystatechange = function() {
         if(sendAlert){
             var response = xhttp.responseText
             if(response){
                 sendAlert = false;
                 if (response.search("error") != -1){
                     alert("Add Member failed: "+response);
                 }else if(response.search("success") != -1){
                     alert("Member: (Name"+name+", Surname: "+surname+") added.");
                 }
             }
           }
         }
     xhttp.send(obj);
}
