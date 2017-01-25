function enableBootstrapComponents() {
  $("a[rel~=popover], .has-popover:not(.popover-click)").popover({
      trigger: 'hover'
  });
  $(".popover-click").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
}

document.addEventListener("turbolinks:before-cache", function() {
  // make sure tooltips are completely cleaned up when we navigate
  // via turbolinks
  $("a[rel~=tooltip], .has-tooltip")
    .tooltip('destroy')
    .attr('data-original-title', '');
});

//
// make sure we activate on first load (in particular tests don't work well
// with just turbolinks:load) and also on any subsequent page change via
// turbolinks
$(document).on('turbolinks:load', enableBootstrapComponents);
jQuery(enableBootstrapComponents);
