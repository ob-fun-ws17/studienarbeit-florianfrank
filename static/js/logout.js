function logoutUser(){

    var obj = '{"key":'+0+'}'

    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/logoutUser", true);
     xhttp.setRequestHeader("Content-type", "application/json");
     var sendAlert = true;
     xhttp.onreadystatechange = function() {
         if(sendAlert){
             var response = xhttp.responseText
             if(response){
                 sendAlert = false;
                 if (response.search("error") != -1){
                     alert("Logout Failed: "+response);
                 }else if(response.search("success") != -1){
                     alert("You are sucessfully logged out");
                 }
             }
           }
         }
     xhttp.send(obj);
}
