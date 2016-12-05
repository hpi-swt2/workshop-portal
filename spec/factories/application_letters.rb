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
    grade 10
    experience "None"
    motivation "None"
    coding_skills "None"
    emergency_number "01234567891"
    vegeterian false
    vegan false
    allergic true
    allergies "Many"
    user
    event
  end


  factory :application_letter_deadline_over, parent: :application_letter do
    association :event, factory: :event, application_deadline: Date.yesterday
  end

  factory :application_letter_accepted, parent: :application_letter do
    status :accepted
  end

  factory :application_letter_rejected, parent: :application_letter do
    status :rejected
  end
end
