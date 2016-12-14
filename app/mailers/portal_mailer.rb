class PortalMailer < ApplicationMailer
  
  # @param recipients [Array<String>] - email addresses of recipients - can be a string of comma separated email adresses too
  # @param reply_to [Array<String>] - email addresses of recipient of the answer - can be a string of comma separated email adresses too
  # @param subject [String] - subject of the mail
  # @param content [String] - content of the mail
  # @return [ActionMailer::MessageDelivery] a mail object with the given parameters.
  def generic_email(recipients, reply_to, subject, content)
    @content = content
    mail(to: recipients, reply_to: reply_to, subject: subject)
  end
end
