// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function() {
    $('#send-emails-clipboard').click(function () {
        var recipients = $('#email_recipients')
        if(recipients.val().length > 0) {
            recipients.select();
            try {
                document.execCommand('copy');
            } catch (err) {
                console.log('Unable to copy emails to the clipboard');
            }
        }
    });

    $('.email-template.list-group-item').click(function (e) {
        e.preventDefault();
        var subject = $(this).children('.template-subject')[0].innerHTML;
        var content = $(this).children('.template-content')[0].innerHTML;
        var hide_recipients = $(this).children('.template-hide_recipients')[0].innerHTML == "true";

        $('#email_subject').val(subject);
        $('#email_content').val(content);

        var show_recipients_button = $('#email_hide_recipients_false');
        var hide_recipients_button = $('#email_hide_recipients_true');

        show_recipients_button.attr('checked', !hide_recipients);
        show_recipients_button.parent().toggleClass('active', !hide_recipients);
        hide_recipients_button.attr('checked', hide_recipients);
        hide_recipients_button.parent().toggleClass('active', hide_recipients);
    });
});