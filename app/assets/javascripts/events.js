// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function() {

    $('#send-emails-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var header = button.data('title');
        var list = button.data('list');
        var modal = $(this);
        modal.find('.modal-title').text(header);
        modal.find('#send-emails-mailto').attr('href', 'mailto:' + list);
        modal.find('#send-emails-list').val(list);
    });

    $('#send-emails-clipboard').click(function () {
        var $temp = $("<input>");
        $('body').append($temp);
        $temp.val($('#send-emails-list').val()).select();
        try {
            var successful = document.execCommand('copy');
            var msg = successful ? 'successful' : 'unsuccessful';
            console.log('Copying emails to the clipboard was ' + msg);
        }
        catch (err) {
            console.log('Unable to copy emails to the clipboard');
        }
        $temp.remove();
    });
});

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
