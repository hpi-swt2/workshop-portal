# == Schema Information
#
# Table name: email_templates
#
#  id              :integer          not null, primary key
#  content         :text
#  hide_recipients :boolean
#  status          :integer
#  subject         :string
#

FactoryGirl.define do
  factory :email_template do
    status :acceptance
    hide_recipients false
    subject "EmailTemplate-Subject"
    content "EmailTemplate-Content"

    trait :default do
      status :default
    end

    trait :acceptance do
      status :acceptance
    end

    trait :rejection do
      status :rejection
    end
  end
end
