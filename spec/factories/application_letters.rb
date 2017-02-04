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
    motivation "None"
    coding_skills "None"
    emergency_number "01234567891"
    organisation "Schule am Griebnitzsee"
    vegetarian false
    vegan false
    allergies "Many"
    user
    event
    annotation "Some"
    custom_application_fields ["Value 1", "Value 2", "Value 3"]
    status_notification_sent false
  end

  factory :application_letter2, parent: :application_letter do
    grade 11
    motivation "Ich bin sehr motiviert, glaubt mir."
    emergency_number "110"
    vegetarian true
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

  factory :application_letter_canceled, parent: :application_letter do
    status :canceled
  end

  factory :accepted_application_with_agreement_letters, parent: :application_letter do
    status :accepted
    after(:build) do |application_letter|
      FactoryGirl.create(:real_agreement_letter, user: application_letter.user, event: application_letter.event)
    end
  end
end
