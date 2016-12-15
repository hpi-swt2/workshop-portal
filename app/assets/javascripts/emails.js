// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function() {
    $(document).on('click', "#send-emails-clipboard", function() {
        console.log('Test');
        $("#email_recipients").select();
        try {
           document.execCommand('copy');
        } catch (err) {
            console.log('Unable to copy emails to the clipboard');
        }
    });
});