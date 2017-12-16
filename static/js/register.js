function register(){
    var mail = document.querySelector("#mail").value;
    var password = document.querySelector("#password").value;
    var obj = '{ "mail":"'+mail+'", "password":"'+password+'"}'
    var xhttp = new XMLHttpRequest();
     xhttp.open("POST", "http://localhost:8080/register", true);
     xhttp.setRequestHeader("Content-type", "application/json");
     xhttp.send(obj);
     alert("You are sucessfully registered")
}
