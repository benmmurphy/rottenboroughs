    (function() {

      function make_heat_map() {
        for (var i = 0; i < counties.length; ++i) {
          var county = counties[i];
          if (bad_counties.indexOf(county) < 0) {
            var data = window.council_data[county];

            var svg = document.getElementById(county);
            svg.style.fill = data.color;
          }

        }
      }

    var counties = ["Barking and Dagenham","Barnet","Barnsley","Bath and North East Somerset","Bedford","Bexley","Birmingham","Blackburn with Darwen","Blackpool","Bolton","Bournemouth","Bracknell Forest","Bradford","Brent","Brighton and Hove","Bristol","Bromley","Buckinghamshire","Bury","Calderdale","Cambridgeshire","Camden","Central Bedfordshire","Cheshire East","Cheshire West and Chester","City of London","Cornwall","County Durham","Coventry","Croydon","Cumbria","Darlington","Derby","Derbyshire","Devon","Doncaster","Dorset","Dudley","Ealing","East Riding of Yorkshire","East Sussex","Enfield","Essex","Gateshead","Gloucestershire","Greenwich","Hackney","Halton","Hammersmith and Fulham","Hampshire","Haringey","Harrow","Hartlepool","Havering","Herefordshire","Hertfordshire","Hillingdon","Hounslow","Ireland","Isle of Wight","Isles of Scilly","Islington","Kensington and Chelsea","Kent","Kingston upon Hull","Kingston upon Thames","Kirklees","Knowsley","Lambeth","Lancashire","Leeds","Leicester","Leicestershire","Lewisham","Lincolnshire","Liverpool","Luton","Manchester","Medway","Merton","Middlesbrough","Milton Keynes","Newcastle upon Tyne","Newham","Norfolk","North East Lincolnshire","North Lincolnshire","North Somerset","North Tyneside","North Yorkshire","Northamptonshire","Northern Ireland","Northumberland","Nottingham","Nottinghamshire","Oldham","Oxfordshire","Peterborough","Plymouth","Poole","Portsmouth","Reading","Redbridge","Redcar and Cleveland","Richmond upon Thames","Rochdale","Rotherham","Rutland","Salford","Sandwell","Scotland","Sefton","Sheffield","Shropshire","Slough","Solihull","Somerset","South Gloucestershire","South Tyneside","Southampton","Southend-on-Sea","Southwark","St Helens","Staffordshire","Stockport","Stockton-on-Tees","Stoke-on-Trent","Suffolk","Sunderland","Surrey","Sutton","Swindon","Tameside","Telford and Wrekin","Thurrock","Torbay","Tower Hamlets","Trafford","Wakefield","Wales","Walsall","Waltham Forest","Wandsworth","Warrington","Warwickshire","West Berkshire","West Sussex","Westminster","Wigan","Wiltshire","Windsor and Maidenhead","Wirral","Wokingham","Wolverhampton","Worcestershire","York"];
    var bad_counties = ["Ireland", "Kensington and Chelsea", "Northern Ireland", "Scotland", "St Helens", "Wales"];

     $(function() {
      make_heat_map();
      
      for (var i = 0; i < counties.length; ++i) {
        var svg = $(document.getElementById(counties[i]));

        svg.mouseover(function(e) {
          var county = this.id;

          if (bad_counties.indexOf(county) < 0) {
            this.style.strokeWidth = "4px";
            var popover = $("#popover");
            popover.css("left", e.pageX);
            popover.css("top", e.pageY);
            $("#location").text(this.id);
            var data = window.council_data[this.id];
            $("#chief_salary").text(format( "#,##0.", data.chief_executive_salary));
            popover.css("display", "block");

          }
        });

        svg.mouseout(function() {
          this.style.strokeWidth = "1px";
          $("#popover").style("display", "none");
        });
      }
      
     });

   })();