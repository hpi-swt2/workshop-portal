FactoryGirl.define do
  factory :email do
    hide_recipients false
    recipients "Email-Recipients"
    reply_to "Email-ReplyTo"
    subject "Email-Subject"
    content "Email-Content"
  end
end
