class PortalMailer < ApplicationMailer
  def generic_email(hideRecipients, recipients, subject, content)
    @content = content
    if (hideRecipients)
      mail(bcc: recipients, subject: subject)
    else
      mail(to: recipients, subject: subject)
    end
  end
end
