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
    status :pre_accepted
    hide_recipients false
    subject "EmailTemplate-Subject"
    content "EmailTemplate-Content"
  end

  factory :email_template_pre_accepted, parent: :email_template do
    status :pre_accepted
  end

  factory :email_template_rejected, parent: :email_template do
    status :rejected
  end
end