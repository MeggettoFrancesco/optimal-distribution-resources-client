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
  var request_matrix_size = $('#request_matrix_size');
  if(request_matrix_size.length) {
    var value = request_matrix_size[0].value;
    dynamicTableCreation(value);
  }
});


// Table buttons click
$(document).on('click', '.input_matrix_button', function() {
  var currentInput = $(this);
  var size = parseInt($('#request_matrix_size')[0].value);

  // avoid toggling in diagonal
  if (this.id == 0 || this.id % (size + 1) == 0) {
    return;
  }

  // toggle text and value
  toggleTextValueOfButton(currentInput);
  // if 'is_directed_graph' is set, update mirror value
  if ($('#is_directed_graph')[0].checked) {
    var x = parseInt(this.id / size, size);
    var y = this.id - (size * x);
    var mirrorInput = $('input#' + (y * size + x));
    copyStateOfSourceInput(currentInput, mirrorInput)
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
      var new_id = (i * number) + j;
      new_button = "<input type='button' name='request[odr_api_matrix][]' class='input_matrix_button' id=" + new_id + " value='0'>"
      table += "<td>" + new_button + "</td>";
    }
    table += "</tr>";
  }

  return table + end_table
}
