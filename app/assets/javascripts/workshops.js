// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  function fixDatePickerNumbers() {
    // iterate over all elements and make sure that their indices are sequential
    // (this is necessary if e.g. the first of three pickers is deleted)
    $('#workshop-date-pickers div').each(function(num, el) {
      $(el).find('[name*=start_date_], [name*=end_date_]').each(function(i, select) {
        var $select = $(select);
        $select.attr('name', $select.attr('name').replace(/_\d+(\[.+\])$/, '_' + num + '$1'));
      });
    });
  }

  $('#workshop-add-date-picker').click(function() {
    // increment our count field
    var $count = $('[name=\'date_ranges_count\']');
    var number = parseInt($count.val()) || 0;
    $count.val(number + 1);

    var template = WORKSHOP_DATE_PICKER_TEMPLATE
      .replace(new RegExp('_XXX', 'g'), '_' + number);

    // insert our template to the ui and add a remove button
    $(template)
      .insertBefore(this)
      .append(' <a style="float: none" class="close">&times;</a>')
      .find('.close')
      .click(function() {
        // remove our template and decrement our count field
        $(this).parent('div').remove();
        fixDatePickerNumbers();

        var $count = $('[name=\'date_ranges_count\']');
        var number = parseInt($count.val()) || 0;
        $count.val(number - 1);
      });
  });
});

