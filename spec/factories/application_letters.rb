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
#  status      :boolean

FactoryGirl.define do
  factory :application_letter do
    motivation "MyString"
    user
    event
    status nil
  end

  factory :application_letter_accepted, parent: :application_letter do
    status true
  end

  factory :application_letter_rejected, parent: :application_letter do
    status false
  end
end
