# == Schema Information
#
#  hide_recipients        :boolean          not null
#  recipients             :string           not null
#  reply_to               :string           not null
#  subject                :string           not null
#  content                :string           nol null
#
FactoryGirl.define do
  factory :email do
    hide_recipients false
    recipients "Email-Recipients"
    reply_to "Email-ReplyTo"
    subject "Email-Subject"
    content "Email-Content"
  end
end