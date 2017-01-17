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

function addEventDatePicker() {
  var picker = $('#event-add-date-picker');

  $(EVENT_DATE_PICKER_TEMPLATE)
    .insertBefore(picker);

  enableDatepickers();
}

function removeEventDatePicker(button) {
  $(button).parent('div').remove();
}

function flipAllCheckboxes(rootCheckbox) {
  if (rootCheckbox.checked) {
    jQuery(':checkbox.'.concat(rootCheckbox.className)).each(function() {
      this.checked = true;
    });
  } else {
    jQuery(':checkbox.'.concat(rootCheckbox.className)).each(function() {
      this.checked = false;
    });
  }
}

document.addEventListener('turbolinks:load', function() {
  $('.colorselector').colorselector();
  $('#downloadLettersForm').submit(function() {
    $('[name="selected_participants[]"]').each(function() {
      if (this.checked) {
        var input = document.createElement("input");
        input.setAttribute("type", "hidden");
        input.setAttribute("name", this.name);
        input.setAttribute("value", this.value);
        document.getElementById("downloadLettersForm").appendChild(input);
      }
    });
  });
});
