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
  var currentButton = $(this);
  var size = parseInt($('#request_matrix_size')[0].value);

  // avoid toggling in diagonal
  if (this.id == 0 || this.id % (size + 1) == 0) {
    return;
  }

  // toggle text and value
  toggleTextValueOfButton(currentButton);
  // if 'is_directed_graph' is set, update mirror value
  if ($('#is_directed_graph')[0].checked) {
    var x = parseInt(this.id / size, size);
    var y = this.id - (size * x);
    var mirrorButton = $('button#' + (y * size + x));
    copyStateOfSourceButton(currentButton, mirrorButton)
  }
});

function toggleTextValueOfButton(btn) {
  if(btn.text() == 0) {
    btn.text(1);
    this.value = 1;
  } else {
    btn.text(0);
    this.value = 0;
  }
}

function copyStateOfSourceButton(source, destination) {
  destination.text(source.text());
  destination.value = source.value;
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
      var new_id = (i * number) + j;
      new_button = "<button type='button' class='input_matrix_button' id=" + new_id + " value='0'>0</button>"
      table += "<td>" + new_button + "</td>";
    }
    table += "</tr>";
  }

  return table + end_table
}
