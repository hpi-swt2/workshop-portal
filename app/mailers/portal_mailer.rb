class PortalMailer < ApplicationMailer
  
  # @param recipients [Array<String>] - email addresses of recipients - can be a string of comma separated email adresses too
  # @param reply_to [Array<String>] - email addresses of recipient of the answer - can be a string of comma separated email adresses too
  # @param subject [String] - subject of the mail
  # @param content [String] - content of the mail
  # @param some_attachments - array of hashes with name and content
  # @return [ActionMailer::MessageDelivery] a mail object with the given parameters.
  def generic_email(recipients, reply_to, subject, content, some_attachments = [])
    some_attachments.each do |attachment|
      attachments[attachment[:name]] = attachment[:content]
    end
    mail(to: recipients, reply_to: reply_to, subject: subject, body: content)
  end
end
