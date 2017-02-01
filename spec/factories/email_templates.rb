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
    status :acceptance
    hide_recipients false
    subject "EmailTemplate-Subject"
    content "EmailTemplate-Content"
  end

  factory :email_template_acceptance, parent: :email_template do
    status :acceptance
  end

  factory :email_template_rejection, parent: :email_template do
    status :rejection
  end

  factory :email_template_default, parent: :email_template do
    status :default
  end
end