// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function addEventDatePicker() {
  var picker = $('#event-add-date-picker');

  $(EVENT_DATE_PICKER_TEMPLATE)
    .insertBefore(picker)
    .append(' <a style="float: none" class="close">&times;</a>')
    .find('.close')
    .click(function() {
      $(this).parent('div').remove();
    });
}
