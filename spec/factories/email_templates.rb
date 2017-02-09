# == Schema Information
#
# Table name: email_templates
#
#  id               :integer          not null, primary key
#  status           :integer(enum)    not null
#  hide_recipients  :boolean          not null
#  subject          :string           not null
#  content          :string           not null
#
FactoryGirl.define do
  factory :email_template do
    status :accepted
    hide_recipients false
    subject "EmailTemplate-Subject"
    content "EmailTemplate-Content"

    trait :default do
      status :default
    end

    trait :accepted do
      status :accepted
    end

    trait :rejected do
      status :rejected
    end
  end
end