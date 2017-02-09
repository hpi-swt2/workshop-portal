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

function enableMultilinePlaceholder(){
  // work around so that we can have a multiline placeholder
  $("#description")
    .val(function(index, oldVal) {
      if (!oldVal) {
        $(this).css('color', '#bbb');
        return EVENT_DESCRIPTION_PLACEHOLDER;
      }
      return oldVal;
    })
    .focus(function(){
      if($(this).val() === EVENT_DESCRIPTION_PLACEHOLDER){
        $(this).val('').css('color', '#000');
      }
    })
    .blur(function(){
      if($(this).val() ===''){
        $(this).val(EVENT_DESCRIPTION_PLACEHOLDER).css('color', '#bbb');
      }
    })
    .parents("form").on("submit", function() {
      $("#description").val(function(index, oldVal) {
        return oldVal == EVENT_DESCRIPTION_PLACEHOLDER ? '' : oldVal;
      });
    });
}
// make sure multiline placeholders also work if the page is called via turbolink
$(document).on('turbolinks:load', enableMultilinePlaceholder);
jQuery(enableMultilinePlaceholder);

function addCustomApplicationField() {
  jQuery(CUSTOM_APPLICATION_FIELD_TEMPLATE)
    .insertBefore('#add-custom-application-fields');
}

function removeCustomApplicationField(button) {
  jQuery(button).parents('.input-group').remove();
}

function addEventDatePicker() {
  var picker = jQuery('#event-add-date-picker');

  jQuery(EVENT_DATE_PICKER_TEMPLATE)
    .insertBefore(picker);

  enableDatepickers();
}

function removeEventDatePicker(button) {
  jQuery(button).parent('div').remove();
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

function ajaxUpdateParticipantColor(form, errorMessage) {
  if (!window.FormData)
    return form.submit();

  var xhr = new XMLHttpRequest();
  xhr.open(form.method, form.action);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.onload = function() {
    if (xhr.status < 200 || xhr.status >= 300)
      return alert(errorMessage);
  };
  xhr.onerror = function() {
      alert(errorMessage);
  };

  xhr.send(new FormData(form));
}
