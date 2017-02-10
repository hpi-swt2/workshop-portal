// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function enableOwlCarousel() {
	$(".owl-carousel").owlCarousel({
		center: false,
		item: 2,
		autoplay: true,
		loop: true,
		dots: true,
		margin: 30,
		nav: true,
		navText: [
      "<i class='icon-chevron-left icon-white'><</i>",
      "<i class='icon-chevron-right icon-white'>></i>" ]
	});
}

jQuery(document).on('turbolinks:load', enableOwlCarousel);
jQuery(enableOwlCarousel);

