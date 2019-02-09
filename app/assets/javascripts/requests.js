// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function toggle_input_type(input_type) {
  if (input_type == "input_matrix") {
    $("#input_matrix_buttons").show();
    $("#input_map").hide();
  }
  else {
    $("#input_matrix_buttons").hide();
    $("#input_map").show();
    map.invalidateSize();
  }
}

// Update min lat, max lat, min lon, max lon of the view on map click
// TODO : add on zoom too!!
$(document).on('click', '#map', function() {
  var coordinates = map.getBounds();
  $('#request_min_latitude').val(coordinates['_southWest']['lat']);
  $('#request_max_latitude').val(coordinates['_northEast']['lat']);
  $('#request_min_longitude').val(coordinates['_southWest']['lng']);
  $('#request_max_longitude').val(coordinates['_southWest']['lng']);
});

function centerMap(arrayOfLatLngs) {
  console.log("HERE");
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
  // if 'is_directed_graph' is set, update mirror value
  if ($('#is_directed_graph')[0].checked) {
    var mirrorInput = $('input#request_odr_api_matrix\\[' + point['y'] + '\\]\\[' + point['x'] + '\\]');
    copyStateOfSourceInput(currentInput, mirrorInput);
  }
});

function toggleTextValueOfButton(input) {
  if(input.val() == 0) {
    input.val(1);
  } else {
    input.val(0);
  }
}

function copyStateOfSourceInput(source, destination) {
  destination.val(source.val());
}

function dynamicTableCreation(number) {
  $('#input_table').html(generateTable(number));
}

function generateTable(number) {
  var table = "<table><tr>";
  var end_table = "</table>";

  for (var i = 0; i < number; i++) {
    table += "<tr>";
    for (var j = 0; j < number; j++) {
      new_button = "<input type='text' value='0' name='request[odr_api_matrix[" + i + "][" + j + "]]' id='request_odr_api_matrix[" + i + "][" + j + "]' readonly='readonly' class='button input_matrix_button'>";
      table += "<td style='display: inline-block' >" + new_button + "</td>";
    }
    table += "</tr>";
  }

  return table + end_table;
}

function extractXAndYFromId(currId) {
  var after_regex = currId.match(/\[([^\]]+)\]/g);
  var x = after_regex[0].replace(/[\[\]']+/g,'');
  var y = after_regex[1].replace(/[\[\]']+/g,'');
  return { x: x, y: y };
}
