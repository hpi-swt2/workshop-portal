FactoryGirl.define do
  factory :email do
    hide_recipients false
    recipients "MyString"
    reply_to "MyString"
    subject "MyString"
    content "MyString"
  end
end
