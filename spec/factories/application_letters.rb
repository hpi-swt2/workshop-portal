# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  workshop_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :boolean

FactoryGirl.define do
  factory :application_letter do
    motivation "MyString"
    user
    workshop
    status nil
  end
  
  factory :accepted_application_letter, parent: :application_letter do
    status true
  end
end
