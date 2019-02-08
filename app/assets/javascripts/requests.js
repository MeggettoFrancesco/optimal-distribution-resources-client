// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function toggle_input_type(input_type) {
  if (input_type == "input_matrix") {
    $("#input_matrix_buttons").show();
    $("#map").hide();
  }
  else {
    $("#input_matrix_buttons").hide();
    // TODO : need to call map.invalidateSize();
    $("#map").show();
  }
}

// Create input table
$(document).on('change', '#request_matrix_size', function() {
  dynamicTableCreation(this.value);
});

// Create input table on load with default value
$(function () {
  value = $('#request_matrix_size')[0].value;
  dynamicTableCreation(value);
});


// Table buttons click
$(document).on('click', '.input_matrix_button', function() {
  console.log('here');
  var currentButton = $(this);
  var size = parseInt($('#request_matrix_size')[0].value) + 1;

  // avoid toggling in diagonal
  if (this.id == 0 || this.id % size == 0) {
    return;
  }

  if(currentButton.text() == 0) {
    currentButton.text(1);
    this.value = 1;
  } else {
    currentButton.text(0);
    this.value = 0;
  }
});

function dynamicTableCreation(number) {
  $('#input_table').html(generateTable(number));
}

function generateTable(number) {
  var table = "<table><tr>";
  var end_table = "</table>";

  for (var i = 0; i < number; i++) {
    table += "<tr>";
    for (var j = 0; j < number; j++) {
      var new_id = (i * number) + j;
      new_button = "<button type='button' class='input_matrix_button' id=" + new_id + " value='0'>0</button>"
      table += "<td>" + new_button + "</td>";
    }
    table += "</tr>";
  }

  return table + end_table
}
