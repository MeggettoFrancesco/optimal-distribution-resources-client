// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function toggle_input_type(input_type) {
  if (input_type == "input_matrix_request") {
    $("#input_matrix_buttons").show();
    $("#input_map").hide();
  }
  else {
    $("#input_matrix_buttons").hide();
    $("#input_map").show();
    setMapGpsCoordinate();
    setCoordinateLabelsValues();
    map.invalidateSize();
  }
}

function setMapGpsCoordinate() {
  map.locate({setView : true});
}

// Update min lat, max lat, min lon, max lon of the view on map click
$(document).on('click', '#map', function() {
  setCoordinateLabelsValues();
});

function setCoordinateLabelsValues() {
  var coordinates = map.getBounds();
  $('#request_open_street_map_request_attributes_min_latitude').val(coordinates['_southWest']['lat']);
  $('#request_open_street_map_request_attributes_max_latitude').val(coordinates['_northEast']['lat']);
  $('#request_open_street_map_request_attributes_min_longitude').val(coordinates['_southWest']['lng']);
  $('#request_open_street_map_request_attributes_max_longitude').val(coordinates['_northEast']['lng']);
}

// Center the map to display all markers
$(document).ready(function() {
  var markers = [];
  Object.keys(map._layers).forEach(function (key) { 
    var value = map._layers[key]._latlng;
    if (typeof value !== 'undefined') {
      markers.push([value['lat'], value['lng']]);
    }
  });

  if (markers.length > 0) {
    map.fitBounds(markers);
  }
});

function centerMap(arrayOfLatLngs) {
  var bounds = new L.LatLngBounds(arrayOfLatLngs);
  map.fitBounds(bounds);
}

// Create input table
$(document).on('change', '#request_matrix_size', function() {
  dynamicTableCreation(this.value);
});

// Create input table on load with default value
$(function () {
  var request_matrix_size = $('#request_matrix_size');
  if(request_matrix_size.length) {
    var value = request_matrix_size[0].value;
    dynamicTableCreation(value);
  }
});

// Table buttons click
$(document).on('click', '.input_matrix_button', function() {
  var currentInput = $(this);

  // avoid toggling in diagonal
  var point = extractXAndYFromId(this.id);
  if (point['x'] == point['y']) {
    return;
  }

  // toggle text and value
  toggleTextValueOfButton(currentInput);
  // if 'request_input_matrix_request_attributes_is_directed_graph' is set, update mirror value
  if (!$('#request_input_matrix_request_attributes_is_directed_graph')[0].checked) {
    var mirrorInput = $('input#request_odr_api_matrix\\[' + point['y'] + '\\]\\[' + point['x'] + '\\]');
    mirrorInput.val(currentInput.val());
  }
});

function toggleTextValueOfButton(input) {
  if(input.val() == 0) {
    input.val(1);
  } else {
    input.val(0);
  }
}

function dynamicTableCreation(number) {
  $('#input_table').html(generateTable(number));
}

function generateTable(number) {
  var table = "<table><tr>";
  var end_table = "</table>";

  table += tableVerticalHeader(number);

  for (var i = 0; i < number; i++) {
    table += "<tr>";
    table += tableHorizontalHeader(i + 1);
    for (var j = 0; j < number; j++) {
      new_button = "<input type='text' value='0' name='request[odr_api_matrix[" + i + "][" + j + "]]' id='request_odr_api_matrix[" + i + "][" + j + "]' readonly='readonly' class='button input_matrix_button'>";
      table += "<td>" + new_button + "</td>";
    }
    table += "</tr>";
  }

  return table + end_table;
}

function tableVerticalHeader(number) {
  new_th = "<th><input disabled class='button input_matrix_button_header' type='text'></th>";
  for (var i = 0; i < number; i++) {
    new_th += "<th><input value=" + (i + 1) + " disabled class='button input_matrix_button_header' type='text'></th>";
  }
  return new_th;
}

function tableHorizontalHeader(number) {
  return "<th><input value=" + number + " disabled class='button input_matrix_button_header' type='text'></th>";
}

function extractXAndYFromId(currId) {
  var after_regex = currId.match(/\[([^\]]+)\]/g);
  var x = after_regex[0].replace(/[\[\]']+/g,'');
  var y = after_regex[1].replace(/[\[\]']+/g,'');
  return { x: x, y: y };
}

// Automatically trigger click of solution button for refresh every 5 seconds until solution is found
$(document).ready(function() {
  if ($("#solution_refresh_button").length) {
    var counter = 5;

    setInterval(function() {
      counter--;
      if (counter >= 0) {
        $("#solution_refresh_button").html("Refreshing in " + counter);
      }

      if (counter === 0) {
        counter = 5;
        $("#solution_refresh_button").click();
      }

    }, 1000);
  }
});
