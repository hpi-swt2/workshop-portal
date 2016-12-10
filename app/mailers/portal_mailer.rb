class PortalMailer < ApplicationMailer

  # @param hide_recipients [Boolean] - identify whether recipients should be hidden from each other (true) or not (false)
  # @param recipients [Array<String>] - email addresses of recipients
  # @param reply_to [Array<String>] - email addresses of recipient of the answer
  # @param subject [String] - subject of the mail
  # @param content [String] - content of the mail
  # @return [ActionMailer::MessageDelivery] a mail object with the given parameters.
  def generic_email(hide_recipients, recipients, reply_to, subject, content)
    @content = content
    if (hide_recipients)
      mail(bcc: recipients, reply_to: reply_to, subject: subject)
    else
      mail(to: recipients, reply_to: reply_to, subject: subject)
    end
  end
end
