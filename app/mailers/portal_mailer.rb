class PortalMailer < ApplicationMailer
  def generic_email(hideRecipients, recipients, reply_to, subject, content)
    @content = content
    if (hideRecipients)
      mail(bcc: recipients, reply_to: reply_to, subject: subject)
    else
      mail(to: recipients, reply_to: reply_to, subject: subject)
    end
  end
end
