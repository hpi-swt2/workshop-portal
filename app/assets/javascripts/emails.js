// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function() {
    $(document).on('click', "#send-emails-clipboard", function() {
        var recipients = $('#email_recipients')
        if(recipients.val.length > 0) {
            recipients.select();
            try {
                document.execCommand('copy');
            } catch (err) {
                console.log('Unable to copy emails to the clipboard');
            }
        }
    });
});