// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  $('#event-add-date-picker').bind('click', function() {
    var template = EVENT_DATE_PICKER_TEMPLATE;

    // insert our template to the ui and add a remove button
    $(template)
      .insertBefore(this)
      .append(' <a style="float: none" class="close">&times;</a>')
      .find('.close')
      .click(function() {
        // remove our template and decrement our count field
        $(this).parent('div').remove();
      });
  });
});

