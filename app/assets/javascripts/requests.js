// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function toggle_input_type(input_type) {
  if (input_type == "input_matrix") {
    $('#input_matrix_buttons').show();
    $('#map').hide();
  }
  else {
    $('#input_matrix_buttons').hide();
    // TODO : need to call map.invalidateSize();
    $('#map').show();
  }
}
