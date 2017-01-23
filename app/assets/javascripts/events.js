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
});

function addCustomApplicationField() {
  $(CUSTOM_APPLICATION_FIELD_TEMPLATE)
    .insertBefore('#add-custom-application-fields');
}

function removeCustomApplicationField(button) {
  $(button).parents('.input-group').remove();
}

function addEventDatePicker() {
  var picker = $('#event-add-date-picker');

  $(EVENT_DATE_PICKER_TEMPLATE)
    .insertBefore(picker);

  enableDatepickers();
}

function removeEventDatePicker(button) {
  $(button).parent('div').remove();
}

function flipAllCheckboxes(rootCheckbox, className) {
  if (rootCheckbox.checked) {
    jQuery(':checkbox.'.concat(className)).each(function() {
      this.checked = true;
    });
  } else {
    jQuery(':checkbox.'.concat(className)).each(function() {
      this.checked = false;
    });
  }
}
