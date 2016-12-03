// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  $('#event-add-date-picker').bind('click', function() {
    // insert our template to the ui and add a remove button
    $(EVENT_DATE_PICKER_TEMPLATE)
      .insertBefore(this)
      .append(' <a style="float: none" class="close">&times;</a>')
      .find('.close')
      .click(function() {
        $(this).parent('div').remove();
      });
  });
});

