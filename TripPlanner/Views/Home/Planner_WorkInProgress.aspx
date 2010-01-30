<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Trip Planner
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">



    <h2>Multi-point routing</h2>
    <ul>
    <li>Specify the start location. You can either enter an address at the bottom or click on the map.
    <li>Specify the destination. You can either enter an address at the bottom or click on the map.
    <li>Three inactive intermediate points will appear.
    <li>When you drag an inactive intermediate point it becomes active.
    <li>You can also drag the start and end points.
    <li>Click on "get directions".
    <li>If the route cannot be calculated, or is not suitable, adjust the
        positions of the points, and try again.
    </ul>

    <table>

      <tr>
        <td width=700>
          <div id="map" style="width: 700px; height: 600px; border:1px solid black"></div>
        </td>
        <td width=400>
          <div id="path" style="width: 400px; height: 600px; overflow:auto; border:1px solid black"></div>
        </td>
      </tr>
    </table>

    

    <div id="start">
      Enter the address of the starting point or click the map.
      <form onsubmit="showAddress(); return false" action="#">
        <input id="search" size="60" type="text" value="" />
        <input type="submit" value="Find start address" />
      </form>
    </div>

    <div id="end">
      Enter the address of the destination point or click the map.
      <form onsubmit="showAddress(); return false" action="#">

        <input id="search2" size="60" type="text" value="" />
        <input type="submit" value="Find destination address" />
      </form>
    </div>

    <div id="drag">
       Drag the markers as required.
       <input type="button" value="Get Directions" onclick="directions()" />
    </div>

    <a href="directions.htm">Back to the tutorial page</a>

    
    <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b> 
      However, it seems JavaScript is either disabled or not supported by your browser. 
      To view Google Maps, enable JavaScript by changing your browser options, and then 
      try again.
    </noscript>
    <script type="text/javascript">
        //<![CDATA[

        if (GBrowserIsCompatible()) {

            var map = new GMap(document.getElementById("map"));
            map.addControl(new GLargeMapControl());
            map.addControl(new GMapTypeControl());
            map.setCenter(new GLatLng(40, -100), 5);

            var bounds = new GLatLngBounds();

            // ====== Create a Client Geocoder ======
            var geo = new GClientGeocoder(new GGeocodeCache());

            // ====== Array for decoding the failure codes ======
            var reasons = [];
            reasons[G_GEO_SUCCESS] = "Success";
            reasons[G_GEO_MISSING_ADDRESS] = "Missing Address: The address was either missing or had no value.";
            reasons[G_GEO_UNKNOWN_ADDRESS] = "Unknown Address:  No corresponding geographic location could be found for the specified address.";
            reasons[G_GEO_UNAVAILABLE_ADDRESS] = "Unavailable Address:  The geocode for the given address cannot be returned due to legal or contractual reasons.";
            reasons[G_GEO_BAD_KEY] = "Bad Key: The API key is either invalid or does not match the domain for which it was given";
            reasons[G_GEO_TOO_MANY_QUERIES] = "Too Many Queries: The daily geocoding quota for this site has been exceeded.";
            reasons[G_GEO_SERVER_ERROR] = "Server error: The geocoding request could not be successfully processed.";
            reasons[G_GEO_BAD_REQUEST] = "A directions request could not be successfully parsed.";
            reasons[G_GEO_MISSING_QUERY] = "No query was specified in the input.";
            reasons[G_GEO_UNKNOWN_DIRECTIONS] = "The GDirections object could not compute directions between the points.";

            // ====== Geocoding ======
            function showAddress() {
                if (state == 0) {
                    var search = document.getElementById("search").value;
                    addresses[0] = search;
                }
                if (state == 1) {
                    var search = document.getElementById("search2").value;
                    addresses[4] = search;
                }
                geo.getLatLng(search, function(point) {
                    if (point) {
                        if (state == 1) { doEnd(point) }
                        if (state == 0) { doStart(point) }
                    }
                    else {
                        var result = geo.getCache().get(search);
                        if (result) {
                            var reason = "Code " + result.Status.code;
                            if (reasons[result.Status.code]) {
                                reason = reasons[result.Status.code]
                            }
                        } else {
                            var reason = "";
                        }
                        alert('Could not find "' + search + '" ' + reason);
                    }
                }
        );
            }

            function swapMarkers(i) {
                map.removeOverlay(gmarkers[i]);
                createMarker(path[i], i, icon2);
            }

            var baseIcon = new GIcon(G_DEFAULT_ICON);
            baseIcon.iconSize = new GSize(24, 38);

            var icon1 = G_START_ICON;
            var icon2 = G_PAUSE_ICON;
            var icon3 = G_END_ICON;
            var icon4 = new GIcon(baseIcon, "http://labs.google.com/ridefinder/images/mm_20_white.png");
            icon4.shadow = "http://labs.google.com/ridefinder/images/mm_20_shadow.png";
            icon4.iconSize = new GSize(12, 20);
            icon4.shadowSize = new GSize(22, 20);
            icon4.iconAnchor = new GPoint(6, 20);
            icon4.infoWindowAnchor = new GPoint(5, 1);


            function createMarker(point, i, icon) {
                var marker = new GMarker(point, { draggable: true, icon: icon });
                gmarkers[i] = marker;
                GEvent.addListener(marker, "dragend", function() {
                    path[i] = marker.getPoint();
                    if (!active[i]) {
                        setTimeout('swapMarkers(' + i + ')', 1000);
                    }
                    active[i] = true;
                    addresses[i] = "";
                });
                map.addOverlay(marker);
            }


            // ===== Array to contain the points of the path =====
            var path = [];
            var active = [true, false, false, false, true];
            var gmarkers = [];
            var addresses = [];

            // ===== State Driven Processing =====
            var state = 0;

            function handleState() {
                if (state == 0) {
                    document.getElementById("start").style.display = "block";
                    document.getElementById("end").style.display = "none";
                    document.getElementById("drag").style.display = "none";
                }
                if (state == 1) {
                    document.getElementById("start").style.display = "none";
                    document.getElementById("end").style.display = "block";
                    document.getElementById("drag").style.display = "none";
                }
                if (state == 2) {
                    document.getElementById("start").style.display = "none";
                    document.getElementById("end").style.display = "none";
                    document.getElementById("drag").style.display = "block";
                }
            }

            handleState();

            GEvent.addListener(map, "click", function(overlay, point) {
                if (point) {
                    if (state == 1) { doEnd(point) }
                    if (state == 0) { doStart(point) }
                }
            });

            function doStart(point) {
                createMarker(point, 0, icon1);
                path[0] = point;
                state = 1;
                handleState();
            }

            function doEnd(point) {
                createMarker(point, 4, icon3);
                path[4] = point;
                state = 2;
                handleState();
                for (var i = 1; i < 4; i++) {
                    var lat = (path[0].lat() * (4 - i) + path[4].lat() * i) / 4;
                    var lng = (path[0].lng() * (4 - i) + path[4].lng() * i) / 4;
                    var p = new GLatLng(lat, lng);
                    createMarker(p, i, icon4);
                    path[i] = p;
                }
                bounds.extend(path[0]);
                bounds.extend(path[4]);
                map.setZoom(map.getBoundsZoomLevel(bounds));
                map.setCenter(bounds.getCenter());
            }

            var gdir = new GDirections(null, document.getElementById("path"));

            GEvent.addListener(gdir, "error", function() {
                var code = gdir.getStatus().code;
                var reason = "Code " + code;
                if (reasons[code]) {
                    reason = "Code " + code + " : " + reasons[code]
                }
                alert("Failed to obtain directions, " + reason);
            });

            var poly;
            GEvent.addListener(gdir, "load", function() {
                if (poly) map.removeOverlay(poly);
                poly = gdir.getPolyline();
                map.addOverlay(poly);
            });


            function directions() {
                if (addresses[0]) { var a = addresses[0] + "@" + path[0].toUrlValue(6) }
                else { var a = path[0].toUrlValue(6) }
                if (addresses[4]) { var b = addresses[4] + "@" + path[4].toUrlValue(6) }
                else { var b = path[4].toUrlValue(6) }
                for (var i = 3; i > 0; i--) {
                    if (active[i]) {
                        b = path[i].toUrlValue(6) + " to: " + b;
                    }
                }
                var a = "from: " + a + " to: " + b;
                gdir.load(a, { getPolyline: true });
            }
        }

        // display a warning if the browser was not compatible
        else {
            alert("Sorry, the Google Maps API is not compatible with this browser");
        }

        // This Javascript is based on code provided by the
        // Community Church Javascript Team
        // http://www.bisphamchurch.org.uk/   
        // http://econym.org.uk/gmap/

        //]]>
    </script>

</asp:Content>
