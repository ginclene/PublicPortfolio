var URL = "https://openlibrary.org/search.json?q=";
var URL2 = "https://covers.openlibrary.org/b/id/";
$("#coverDiv").hide();
function submit() {
    $("#coverDiv").show();
    var query = $("#query").val();
    query = query.replace(" ", "+").toLowerCase();
    console.log(URL + query);
    search(query);
}

function search(query) {
    a=$.ajax({
        url: URL + query,
        method: "GET"
    }).done(function(data) {
        console.log(data);
        $("#list").html("");
        var len = data.docs.length;
        for (i=0;i<len;i++) {
            if(typeof data.docs[i].cover_i !== "undefined") {
            $("#list").append("<li class='getCover' isbn= " + data.docs[i].cover_i + ">" + data.docs[i].title + "</li>");
            }
        }
    }).fail(function(error) {
        console.log(error);
    });
}

function getCover(isbn) {
      var url= URL2 + isbn + "-M.jpg";
      console.log("trying to add picture: " + url);
      $("#noImage").html("");
      $("#coverDiv").html("");
      var img = document.createElement("IMG");
      img.src = url;
      $("#coverDiv").html(img);
      console.log("picture should be there");
}
