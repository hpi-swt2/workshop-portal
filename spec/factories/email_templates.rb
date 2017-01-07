FactoryGirl.define do
  factory :email_template do
    status :accepted
    hide_recipients false
    subject "EmailTemplate-Subject"
    content "EmailTemplate-Content"
  end
end