class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.default_reply_to_email
  layout 'mailer'
end
