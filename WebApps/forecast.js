
function getForecast() {
  zipcode = $("#zipcode").val();
  console.log("zipcode is " +zipcode);
  $.ajax({
     url: "https://api.clearllc.com/api/v2/miamidb/_table/zipcode",
     data:  {
       api_key: "bed859b37ac6f1dd59387829a18db84c22ac99c09ee0f5fb99cb708364858818",
       ids: zipcode
     },
      method: "GET"
     })
     .done(function(data)  {
         console.log("done with forecast");
         lat = data.resource[0].latitude;
         lon = data.resource[0].longitude;
         city = data.resource[0].city;
         state = data.resource[0].state;
         $("#top").append("<b>" + city + ", " + state + "</b>");
         $("#grid1").show();
         console.log("sending lat and long values: " + lat + " " + lon);
         getWeather(lat, lon);
      });
 }

function getWeather(lat, lon) {
  console.log("got to weather function");
  var weatherkey = "897a77e870df49f70da8bc941a3f2cf9";
  $.ajax({
    url: "https://api.openweathermap.org/data/2.5/onecall",
    data:  {
      lat: lat,
      lon: lon,
      exclude: "minutely,hourly",
      units: "imperial",
      appid: weatherkey
    },
       method: "GET"
    })
    .done(function(data) {
      console.log("got weather data");
      var today = new Date();
      var day = today.getDay();
      var date = today.getDate();
      var dayid = "day";
      var imgid = "img";
      var tempid = "temp";
      var descid = "desc";
      for (var i = 0; i < data.daily.length; i++) {
        if (day > 6) {
          day = 0;
        }
        if (date > 31) {
          date = 1;
        }
        var d = document.getElementById(dayid + i);
        var day2;
        if (day == 0) {
          day2 = "Sunday";
        } else if (day == 1) {
           day2 = "Monday";
          } else if (day == 2) {
              day2 = "Tuesday";
            } else if (day == 3) {
               day2 = "Wednesday";
              } else if (day == 4) {
                 day2 = "Thursday";
                } else if (day == 5) {
                    day2 = "Friday";
                  } else {
                      day2 = "Saturday";
                    }
        var date2;
        console.log(date);
        if (date == 2 || date == 3 || date == 22 || date == 23) {
          date2 = date + "rd";
        } else if (date == 1 || date == 21 || date == 31) {
           date2 = date + "st"
          } else {
              date2 = date + "th";
            }
        d.innerHTML = day2 + " the " + date2;
        day = day + 1;
        date = date + 1;
      }
      var img = document.createElement("IMG");
      var url = "http://openweathermap.org/img/wn/";
      for (var i = 0; i < data.daily.length; i++) {
        var img = document.createElement("IMG");
        var url = "http://openweathermap.org/img/wn/";
        var type = data.daily[i].weather[0].icon;
        console.log("img type for day " + i + " " + type);
        url = url + type + "@2x.png";
        img.src = url;
        console.log("recieving picture from " + url);
        var div = document.getElementById(imgid + i);
        console.log("adding picture to " + div.id + " div");
        $("#" + div.id).append(img);
      }
      for (var i = 0; i < data.daily.length; i++) {
        var min = data.daily[i].temp.min;
        var max = data.daily[i].temp.max;
        var t = document.getElementById(tempid + i);
        t.innerHTML =  min + " - " + max + " F";
        console.log("adding temps: " + min + " " + max);
      }
      for (var i = 0; i < data.daily.length; i++) {
        var desc = data.daily[i].weather[0].description;
        var de = document.getElementById(descid + i);
        de.innerHTML = desc;
        console.log("adding description: " + desc);
      }
      console.log("weather complete");
   }).fail(function(error) {
       console.log("something went wrong with weather");
       console.log(error);
   });
}


