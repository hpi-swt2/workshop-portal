document.addEventListener('turbolinks:visit', function() {
  $('.loader').show();
});
document.addEventListener('turbolinks:load', function() {
  $('.loader').hide();
});
