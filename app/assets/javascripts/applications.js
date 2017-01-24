// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function ajaxUpdateApplicationStatus(form, errorMessage) {
  if (!window.FormData)
    return form.submit();

  var xhr = new XMLHttpRequest();
  xhr.open(form.method, form.action);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.onload = function() {
    if (xhr.status < 200 || xhr.status >= 300)
      return alert(errorMessage);

    var data = JSON.parse(xhr.responseText);
    $('#free_places').text(data.free_places);
    $('#occupied_places').text(data.occupied_places);
  };
  xhr.onerror = function() {
      alert(errorMessage);
  };

  xhr.send(new FormData(form));
}
