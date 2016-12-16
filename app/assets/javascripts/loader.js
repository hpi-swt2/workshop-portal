document.addEventListener('turbolinks:visit', function() {
  $('.loader').fadeIn();
});
document.addEventListener('turbolinks:load', function() {
  $('.loader').fadeOut();
});
