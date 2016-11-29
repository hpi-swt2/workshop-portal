# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  event_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          not null
#

FactoryGirl.define do
  factory :application_letter do
    motivation "MyString"
    user
    event
  end

  factory :application_letter_accepted, class: :application_letter do
    motivation "MyString"
    user
    event
    status :accepted
  end

  factory :application_letter_rejected, class: :application_letter do
    motivation "MyString"
    user
    event
    status :rejected
  end
end
