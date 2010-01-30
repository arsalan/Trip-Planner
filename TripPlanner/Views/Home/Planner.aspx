﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Trip Planner
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function() {
            $('#map').jmap('init', {
                mapCenter: [37.808445, -122.410161],
                mapShowjMapIcon: false,
                mapZoom: 14,
                mapEnableScaleControl: true,
                mapControlSize: 'large'
            });
            $('#map').jmap('addMarker', {
                pointLatLng: [37.808445, -122.410161]
            });

            $('#getDir').submit(function() {
                $('#directions').empty();
                $('#map').jmap("searchDirections", {
                    toAddress: $('#to').val(),
                    fromAddress: $('#from').val(),
                    directionsPanel: "directions"
                });
                return false;
            });
            var map = new GMap2(document.getElementById("map"));
            GEvent.addListener(map, "click", function() {
                alert("You clicked the map.");
            });

        }); // end ready()
</script>

<div id="contentWrap">
  <div id="main">
  <h1>Trip Map</h1>
  <div id="map"></div>
  <div id="getDirections">
    <form name="directions" id="getDir"  method="post" action="">
      <p>
        <label for="from" class="mapLabel">From: </label>
        <input name="from" type="text" id="from" size="60" />
      </p>
      <p>
        <label for="to" class="mapLabel">To: </label>
        <input name="to" type="text" id="to" size="60" />
      </p>
      <p>
        <input type="submit" name="submit" id="submit" value="Get Directions" />
      </p>
    </form>
  </div>
  <div id="directions"></div>
</div>
  
  <div id="sidebar">
    <h2>&copy 2010 Scient Systems. All Rights Reserved.</h2>
</div>
  </div>

</asp:Content>
