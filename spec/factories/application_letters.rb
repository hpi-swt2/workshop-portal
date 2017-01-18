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
    association :user, factory: :user_with_profile
    event
  end

  factory :application_letter2, parent: :application_letter do
    grade 11
    experience "A lot"
    motivation "Ich bin sehr motiviert, glaubt mir."
    emergency_number "110"
    vegeterian true
  end

  factory :application_letter_long, parent: :application_letter do
    motivation "Ich bin sehr motiviert, glaubt mir." * 200
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

  factory :application_letter_alternative, parent: :application_letter do
    status :alternative
  end

  factory :accepted_application_with_agreement_letters, parent: :application_letter do
    status :accepted
    after(:build) do |application_letter|
      FactoryGirl.create(:real_agreement_letter, user: application_letter.user, event: application_letter.event)
    end
  end
end
