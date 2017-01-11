// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function() {
    $(document).on('click', "#send-emails-clipboard", function() {
        var recipients = $('#email_recipients')
        if(recipients.val.length == 0) {
            recipients.select();
            try {
                document.execCommand('copy');
            } catch (err) {
                console.log('Unable to copy emails to the clipboard');
            }
        }
    });
});

function loadTemplate(elem) {
    console.log(elem);
    var subject = elem.getElementsByClassName('template-subject')[0].innerHTML;
    var content = elem.getElementsByClassName('template-content')[0].innerHTML;

    document.getElementById('email_subject').value = subject;
    document.getElementById('email_content').value = content;
}