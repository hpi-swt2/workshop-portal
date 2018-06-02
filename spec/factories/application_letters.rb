# == Schema Information
#
# Table name: application_letters
#
#  id                        :integer          not null, primary key
#  allergies                 :string
#  annotation                :text
#  custom_application_fields :text
#  emergency_number          :string
#  motivation                :string
#  organisation              :string
#  status                    :integer          default("pending"), not null
#  status_notification_sent  :boolean          default(FALSE), not null
#  vegan                     :boolean
#  vegetarian                :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  event_id                  :integer          not null
#  user_id                   :integer          not null
#
# Indexes
#
#  index_application_letters_on_event_id  (event_id)
#  index_application_letters_on_user_id   (user_id)
#

FactoryGirl.define do
  factory :application_letter do
    motivation "None"
    emergency_number "01234567891"
    organisation "Schule am Griebnitzsee"
    vegetarian false
    vegan false
    status :pending
    allergies "Many"
    association :user, factory: :user_with_profile
    event
    annotation "Some"
    custom_application_fields ["Value 1", "Value 2", "Value 3"]
    status_notification_sent false

    trait :with_notes do
      application_notes { build_list :application_note, 1 }
    end

    trait :alternative_data do
      motivation "Ich bin sehr motiviert, glaubt mir."
      emergency_number "110"
      vegetarian true
    end

    trait :long_motivation do
      motivation "Ich bin sehr motiviert, glaubt mir." * 200
    end

    trait :deadline_over do
      association :event, factory: :event, application_deadline: Date.yesterday
    end

    trait :accepted do
      status :accepted
    end

    trait :rejected do
      status :rejected
    end

    trait :alternative do
      status :alternative
    end

    trait :canceled do
      status :canceled
    end

    trait :with_mail_sent do
      after(:build) do |application|
        application.status_notification_sent = true
      end
    end

    trait :with_agreement_letter do
      after(:build) do |application_letter|
        FactoryGirl.create(:real_agreement_letter, user: application_letter.user, event: application_letter.event)
      end
    end

  end
end
