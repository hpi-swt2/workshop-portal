# Preview all emails at http://localhost:3000/rails/mailers/portal_mailer
class PortalMailerPreview < ActionMailer::Preview
  def generic_email_preview
    PortalMailer.generic_email(true, "mail@example.com", "This is subject", "This is content")
  end
end
