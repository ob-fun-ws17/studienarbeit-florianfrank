function deleteAppointment()
{
    var table = document.getElementById("appointmentTable");
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
            var time  = columns[i2].innerText;
            var hour   = time.substr(0,2); //Hour
            var minute = time.substr(3,2); //Month

            if  (hour[0] == 0)
                hour = hour[1];

            if  (minute[0] == 0)
                minute = minute[1];

            rowValues.push(hour);
            rowValues.push(minute);
        }
        else if (i2 == 5)
        {
            var members = columns[i2].innerText;
            var searchIndexFst = -1;
            var searchIndexSnd = members.indexOf("\n",0);
            var memberlist = [];
            while(searchIndexSnd != -1)
            {
                searchIndexSnd = members.indexOf("\n", searchIndexFst+1);
                if(searchIndexSnd == -1)
                    memberlist.push("\""+members.substr(searchIndexFst+1, (members.length - searchIndexFst)-1)+"\"");
                else
                {
                    memberlist.push("\""+members.substr(searchIndexFst+1, (searchIndexSnd - searchIndexFst)-1)+"\"")
                    searchIndexFst = searchIndexSnd;
                }
            }
            rowValues.push(memberlist);
        }
        else
        {
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
            var row = '{"appointments": [{"title":"'+tableRow[0]+'", "type":"'+tableRow[1]+
                        '", "day":'+tableRow[2]+
                        ', "month":'+tableRow[3]+
                        ', "year":'+tableRow[4]+
                        ', "hour":'+tableRow[5]+
                        ', "minute":'+tableRow[6]+
                        ', "members":['+tableRow[7]+']}]}';
            jsonData.push(row);
        }
        else
        {
            if(i == 0)
            {
                var row = '{"appointments": [{"title":"'+tableRow[0]+'", "type":"'+tableRow[1]+
                            '", "day":'+tableRow[2]+
                            ', "month":'+tableRow[3]+
                            ', "year":'+tableRow[4]+
                            ', "hour":'+tableRow[5]+
                            ', "minute":'+tableRow[6]+
                            ', "members":'+tableRow[7]+'}';
                jsonData.push(row);
            }

            if (i == tableValues.length-1)
            {
                var row = '{"title":"'+tableRow[0]+'", "type":"'+tableRow[1]+
                            '", "day":'+tableRow[2]+
                            ', "month":'+tableRow[3]+
                            ', "year":'+tableRow[4]+
                            ', "hour":'+tableRow[5]+
                            ', "minute":'+tableRow[6]+
                            ', "members":'+tableRow[7]+'}';
                jsonData.push(row);
            }
            else if (i != 0 && i != tableValues.length-1 )
            {
                var row = '{"title":"'+tableRow[0]+'", "type":"'+tableRow[1]+
                            '", "day":'+tableRow[2]+
                            ', "month":'+tableRow[3]+
                            ', "year":'+tableRow[4]+
                            ', "hour":'+tableRow[5]+
                            ', "minute":'+tableRow[6]+
                            ', "members":'+tableRow[7]+'}';
                jsonData.push(row);
            }
        }
    }

    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/deleteAppointment", true);
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
