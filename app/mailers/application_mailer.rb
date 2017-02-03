class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.from_address
  layout 'mailer'
end
