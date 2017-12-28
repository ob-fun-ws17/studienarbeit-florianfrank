$(function () {

    function moveItems(origin, dest) {
        $(origin).find(':selected').appendTo(dest);
        $(dest).find(':selected').removeAttr("selected");
        $(dest).sort_select_box();
    }

    function moveAllItems(origin, dest) {
        $(origin).children("option:visible").appendTo(dest);
        $(dest).find(':selected').removeAttr("selected");
        $(dest).sort_select_box();
    }

    $('.left').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveItems($(container).find('select.multiselect.selected'), $(container).find('select.multiselect.available'));
    });

    $('.right').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveItems($(container).find('select.multiselect.available'), $(container).find('select.multiselect.selected'));
    });

    $('.leftall').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveAllItems($(container).find('select.multiselect.selected'), $(container).find('select.multiselect.available'));
    });

    $('.rightall').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveAllItems($(container).find('select.multiselect.available'), $(container).find('select.multiselect.selected'));
    });

    $('select.multiselect.selected').on('dblclick keyup',function(e){
        if(e.which == 13 || e.type == 'dblclick') {
          var container = $(this).closest('.addremove-multiselect');
          moveItems($(container).find('select.multiselect.selected'), $(container).find('select.multiselect.available'));
        }
    });

    $('select.multiselect.available').on('dblclick keyup',function(e){
        if(e.which == 13 || e.type == 'dblclick') {
            var container = $(this).closest('.addremove-multiselect');
            moveItems($(container).find('select.multiselect.available'), $(container).find('select.multiselect.selected'));
        }
    });


});

$.fn.sort_select_box = function(){
    // Get options from select box
    var my_options =$(this).children('option');
    // sort alphabetically
    my_options.sort(function(a,b) {
        if (a.text > b.text) return 1;
        else if (a.text < b.text) return -1;
        else return 0
    })
   //replace with sorted my_options;
   $(this).empty().append( my_options );

   // clearing any selections
   $("#"+this.attr('id')+" option").attr('selected', false);
}

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

"use strict";!function(){function e(){getmdlSelect.init(".getmdl-select")}window.addEventListener?window.addEventListener("load",e,!1):window.attachEvent&&window.attachEvent("onload",e)}();var getmdlSelect={_defaultValue:{width:300},_addEventListeners:function(e){var t=e.querySelector("input"),n=e.querySelectorAll("li"),l=e.querySelector(".mdl-js-menu");t.onkeydown=function(e){38!=e.keyCode&&40!=e.keyCode||l.MaterialMenu.show()},l.onkeydown=function(e){13==e.keyCode&&t.focus()},[].forEach.call(n,function(n){n.onclick=function(){var a=n.textContent.trim();if(t.value=a,e.MaterialTextfield.change(a),setTimeout(function(){e.MaterialTextfield.updateClasses_()},250),t.dataset.val=n.dataset.val||"","createEvent"in document){var d=document.createEvent("HTMLEvents");d.initEvent("change",!1,!0),l.MaterialMenu.hide(),t.dispatchEvent(d)}else t.fireEvent("onchange")}})},init:function(e,t){var n=document.querySelectorAll(e);[].forEach.call(n,function(e){getmdlSelect._addEventListeners(e);var n=t||(e.querySelector(".mdl-menu").offsetWidth?e.querySelector(".mdl-menu").offsetWidth:getmdlSelect._defaultValue.width);e.style.width=n+"px",componentHandler.upgradeElement(e),componentHandler.upgradeElement(e.querySelector("ul"))})}};
//# sourceMappingURL=getmdl-select.min.js.map

function addAppointment()
{
    var title = document.querySelector("#title").value;
    var type = document.querySelector("#type").value;
    var date = document.querySelector("#datepicker").value;
    var hour = document.querySelector("#hours").value;
    var minute = document.querySelector("#minutes").value;
    var members = document.querySelector("#selected-select").options;

    //Date of appointment
    var month     = date.substr(0, date.search("/"));
    var day   = date.substr(date.search("/")+1,date.length-8);
    var year    = date.substr(date.lastIndexOf("/")+1,date.length);

    var membersList = [];
    //Create a array of members
    for(var i = 0; i< members.length; i++)
    {
        if (members.length == 1)
        {
            membersList.push("[\""+members[i].text+"\"]");
        }
        else
        {
        if (i == 0)
            membersList.push("[\""+members[i].text+"\"");
        else if (i == members.length-1)
            membersList.push("\""+members[i].text+"\"]");
        else
            membersList.push("\""+members[i].text+"\"")
        }
    }

    //parse day an month if string starts with a zero
    if  (month[0] == 0)
        month = month[1];

    if  (day[0] == 0)
        day = day[1];

    var obj = '{"title":"'+title+
                '", "type":"'+type+
                '", "day":'+day+
                ', "month":'+month+
                ', "year":'+year+
                ', "hour":'+hour+
                ', "minute":'+minute+
                ', "members":'+membersList+
                '}';

    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/addAppointment", true);
     xhttp.setRequestHeader("Content-type", "application/json");
     var sendAlert = true;
     xhttp.onreadystatechange = function() {
         if(sendAlert){
             var response = xhttp.responseText
             if(response){
                 sendAlert = false;
                 if (response.search("error") != -1){
                     alert("Add Appointment failed: "+response);
                 }else if(response.search("success") != -1){
                     alert("Appointment: (Title"+title+", Date: "+date+") added.");
                 }
             }
           }
         }
     xhttp.send(obj);
}
