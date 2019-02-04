# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery

$ ->
  map = L.map('map').setView([51.505, -0.09], 15);

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 18
  }).addTo(map)

  onMapMoveEnd = (e) ->
    console.log(map.getBounds());

  map.on('moveend', onMapMoveEnd)
