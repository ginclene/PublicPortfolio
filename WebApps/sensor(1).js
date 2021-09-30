
function sendUpdate() {
  loc = $("#location").val();
  sen = $("#sensor").val();
  value = $("#value").val();
  $.ajax({
    url: "https://api.clearllc.com/api/v2/setTemp",
    data:  {
      userid: "ginclene",
      location: loc,
      sensor: sen,
      value: value,
      api_key: "bed859b37ac6f1dd59387829a18db84c22ac99c09ee0f5fb99cb708364858818"
    },
     method: "GET"
    })
    .done(function(data)  {
      console.log(data);
      console.log(data.status);
      status = data.status;
      console.log(data.message);
      mess = data.message;
      $("#response").html("<h2><b> Status: </h2>" + status + "</b>");
      $("#message").html("<h2><b> Message: </h2>" + mess + "</b>");
      $("#response").show();
      $("#message").show();
     });

}

