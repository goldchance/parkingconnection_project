  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-40783242-1', 'parkingconnect.com');
  ga('send', 'pageview');
  
    var asd = '0'
  $(function() {
    
    $.backstretch("/images/bg_color.png");
    $( document ).tooltip({
      items: "img, [data-geo], [title]",
      content: function() {
        var element = $( this );
        if ( element.is( "[data-geo]" ) ) {
          var text = element.text();
          return "<img class='map' alt='" + text +
            "' src='http://maps.google.com/maps/api/staticmap?" +
            "zoom=11&size=350x350&maptype=terrain&sensor=true&center=" +
            text + "&markers="+text+  "'>";
        }
       
      }
    });
       
    $( ".airport-select" ).click(function() {
    $("#wherebox_airp").val($(this).html());
    $("#wherebox_airp_full").val($(this).attr("href"));
    $("#effect" ).toggle( "slide", {}, 500 );
       return false;
    });
  
    $(document).on('click', '#google_map_button',  function() {
      //$( "#google_map_button" ).click(function() {
    
      var request = $('#results').attr('title') 
      var req_status = $('#results').attr('name')
      if (  req_status == 'no'  ) {
        $('#results').attr('name','yes')
        $.getJSON('/results?request_id='+ request, function(json){
        // var json1 = gon.results
        $(".map_container").show();
          Gmaps.loadMaps();
          Gmaps.map.addMarkers(json);
        })
  
      }
       $( "#google_map" ).toggle( "blind", {}, 500 );
       return false;
    });
    $(".button").button()
    $(".loginform").validate({
  rules: {
    field: {
      required: true,
      email: true
    }
  }
  });
      $(".map_container").hide();
    function log( message ) {
      $( "<div>" ).text( message ).prependTo( "#log" );
      $( "#log" ).scrollTop( 0 );
    }
    $( "#wherebox_airxx" ).autocomplete({
      source: function( request, response ) {
        $.ajax({
          url: "http://ws.geonames.org/searchJSON?country=US",
          dataType: "jsonp",
          data: {
            featureCode: "AIRP",
            style: "full",
            maxRows: 12,
            //lang: "iata",
            name_startsWith: request.term
          },
          success: function( data ) {
            response( $.map( data.geonames, function( item ) {
              return {
                label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", "+ item.alternatenName + "," + item.countryName,
               // label: item.name + (item.alternateName ? ", " + item.alternateName : "")  + ", "+item.adminName2 + "," + item.adminName3 +","+ item.adminName4 + "," + item.countryName,
                value: item.name +","+ item.adminCode1
              }
            }));
          }
        });
      },
      minLength: 2,
      select: function( event, ui ) {
        log( ui.item ?
          "Selected: " + ui.item.label :
          "Nothing selected, input was " + this.value);
      },
      open: function() {
        $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      },
      close: function() {
        $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      }
    });
    $( ".button2" ).click(function() {
      $('#spinner').show()
      $('#spinner').spin()
    });
    $( "#wherebox" ).autocomplete({
      source: function( request, response ) {
        $.ajax({
          url: "http://ws.geonames.org/searchJSON?country=US&username=shpytalenko",
          dataType: "jsonp",
          data: {
            featureClass: "P",
            style: "full",
            maxRows: 12,
            name_startsWith: request.term
          },
          success: function( data ) {
            response( $.map( data.geonames, function( item ) {
              return {
                label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
                value: item.name +","+ item.adminCode1
              }
            }));
          }
        });
      },
      minLength: 2,
      select: function( event, ui ) {
        log( ui.item ?
          "Selected: " + ui.item.label :
          "Nothing selected, input was " + this.value);
      },
      open: function() {
        $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      },
      close: function() {
        $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      }
    });
       $(".button2").click(function() {
        $("#google_map").hide();
        $("#google_map_button").show("slide",{} ,500);
      });

      $("#email_submit").click(function() {
        $(".result").hide();
        return false;
      });
    
      $(".button").button();
    $( ".datepicker" ).datepicker({
    });

 //  $("img").error(function () {
 //    $(this).unbind("error").attr("src", "default.jpg");
 //  });
  });

