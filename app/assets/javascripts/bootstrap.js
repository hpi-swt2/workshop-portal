function enableBootstrapComponents() {
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
}

// make sure we activate on first load (in particular tests don't work well
// with just turbolinks:load) and also on any subsequent page change via
// turbolinks
$(document).on('turbolinks:load', enableBootstrapComponents);
jQuery(enableBootstrapComponents);
