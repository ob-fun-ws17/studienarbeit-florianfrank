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



function deleteMember()
{
    var table = document.getElementById("memberTable");
    var tableRows = table.getElementsByTagName("tr");
    var tableValues = [];
    for(var i=0;i<tableRows.length;i++)
    {
        if(tableRows[i].className == "is-selected")
        {
       var rowValues = [];
       var columns = tableRows[i].getElementsByTagName("td")
       for(var i2 = 1; i2< columns.length; i2++){

        if (i2 == 3) //BirthDay
        {
            var date  = columns[i2].innerText;
            var day   = date.substr(0,2); //Day
            var month = date.substr(3,2); //Month
            var year  = date.substr(6,4); //Year

            if  (month[0] == 0)
                month = month[1];

            if  (day[0] == 0)
                day = day[1];

            rowValues.push(day);
            rowValues.push(month);
            rowValues.push(year);
        }
        else if (i2 == 4) //ExaminationDay
        {
            var date  = columns[i2].innerText;
            var day   = date.substr(0,2); //Day
            var month = date.substr(3,2); //Month
            var year  = date.substr(6,4); //Year

            if  (month[0] == 0)
                month = month[1];

            if  (day[0] == 0)
                day = day[1];

            rowValues.push(day);
            rowValues.push(month);
            rowValues.push(year);
        }
        else
        {
            if (columns[i2].innerText == "Ja")
                rowValues.push(1);
            else if (columns[i2].innerText == "Nein")
                rowValues.push(1);
            else
                rowValues.push(columns[i2].innerText);
        }
    }
       tableValues.push(rowValues);
        }
    }

    var jsonData = [];

    //Create JSON
    for(var i = 0; i< tableValues.length; i++)
    {
        var tableRow = tableValues[i];
        if(i == 0 && i == tableValues.length-1)
        {
            var row = '{"members": [{"name":"'+tableRow[0]+'", "surName":"'+tableRow[1]+
                        '", "birthDay":'+tableRow[2]+
                        ', "birthMonth":'+tableRow[3]+
                        ', "birthYear":'+tableRow[4]+
                        ', "examationDay":'+tableRow[5]+
                        ', "examationMonth":'+tableRow[6]+
                        ', "examationYear":'+tableRow[7]+
                        ', "instructionCheck":'+tableRow[8]+
                        ', "exerciseCheck":'+tableRow[9]+'}]}';
            jsonData.push(row);
        }
        else
        {
            if(i == 0)
            {
                var row = '{"members": [{"name":"'+tableRow[0]+'", "surName":"'+tableRow[1]+
                            '", "birthDay":'+tableRow[2]+
                            ', "birthMonth":'+tableRow[3]+
                            ', "birthYear":'+tableRow[4]+
                            ', "examationDay":'+tableRow[5]+
                            ', "examationMonth":'+tableRow[6]+
                            ', "examationYear":'+tableRow[7]+
                            ', "instructionCheck":'+tableRow[8]+
                            ', "exerciseCheck":'+tableRow[9]+'}';
                jsonData.push(row);
            }

            if (i == tableValues.length-1)
            {
                var row = '{"name":"'+tableRow[0]+'", "surName":"'+tableRow[1]+
                            '", "birthDay":'+tableRow[2]+
                            ', "birthMonth":'+tableRow[3]+
                            ', "birthYear":'+tableRow[4]+
                            ', "examationDay":'+tableRow[5]+
                            ', "examationMonth":'+tableRow[6]+
                            ', "examationYear":'+tableRow[7]+
                            ', "instructionCheck":'+tableRow[8]+
                            ', "exerciseCheck":'+tableRow[9]+'}]}';
                jsonData.push(row);
            }
            else if (i != 0 && i != tableValues.length-1 )
            {
                var row = '{"name":"'+tableRow[0]+'", "surName":"'+tableRow[1]+
                            '", "birthDay":'+tableRow[2]+
                            ', "birthMonth":'+tableRow[3]+
                            ', "birthYear":'+tableRow[4]+
                            ', "examationDay":'+tableRow[5]+
                            ', "examationMonth":'+tableRow[6]+
                            ', "examationYear":'+tableRow[7]+
                            ', "instructionCheck":'+tableRow[8]+
                            ', "exerciseCheck":'+tableRow[9]+'}';
                jsonData.push(row);
            }
        }
    }

    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/deleteMember", true);
     xhttp.setRequestHeader("Content-type", "application/json");
     var sendAlert = true;
     xhttp.onreadystatechange = function() {
         if(sendAlert){
             var response = xhttp.responseText
             if(response){
                 sendAlert = false;
                 if (response.search("error") != -1){
                     alert("Delete Member failed: "+response);
                 }else if(response.search("success") != -1){
                     window.location.reload();
                 }
             }
           }
         }
     xhttp.send(jsonData);

}
