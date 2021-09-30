var button = $("button")
console.log("found js script");
function callMath() {
    console.log("found math function");
    n1 = $("#n1").val();
    console.log("n1 is " + n1);
    n2 = $("#n2").val();
    console.log("n2 is "  +n2);
    op = $("#operator").val();
    console.log("operator is " + op);
    if (op == "Divide" && n2 == 0) {
      $("#answer").html("Error, cannot divide by 0");
      return;
    }
    $.ajax({
        url:  "https://api.clearllc.com/api/v2/math/"+op,
        data:  {
          api_key:  "bed859b37ac6f1dd59387829a18db84c22ac99c09ee0f5fb99cb708364858818",
          n1: n1,
          n2: n2
        },
          method: "GET"
        })
        .done(function(data) {
          console.log("done");
          console.log(data);
          $("#answer").html("<b>" + data.result + "</b>");
         });
     }
