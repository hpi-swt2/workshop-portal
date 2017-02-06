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
	});
}

jQuery(document).on('turbolinks:load', enableOwlCarousel);
jQuery(enableOwlCarousel);

