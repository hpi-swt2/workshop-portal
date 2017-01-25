# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  date_ranges      :collection
#  published        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  hidden           :boolean
#

FactoryGirl.define do
  factory :event do
    name "Event-Name"
    description "Event-Description"
    max_participants 1
    kind :workshop
    published true
    organizer "Workshop-Organizer"
    knowledge_level "Workshop-Knowledge Level"
    application_deadline Date.tomorrow
    custom_application_fields ["Field 1", "Field 2", "Field 3"]
    date_ranges { build_list :date_range, 1 }
    hidden false

    trait :with_two_date_ranges do
      after(:build) do |event|
        event.date_ranges = []
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.tomorrow.next_day(1), end_date: Date.tomorrow.next_day(5))
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.tomorrow.next_day(1), end_date: Date.tomorrow.next_day(10))
      end
    end

    trait :application_deadline_in_10_days do
      application_deadline Date.current.next_day(10)

      after(:build) do |event|
        event.date_ranges = [FactoryGirl.create(:date_range, start_date: Date.tomorrow.next_day(30), end_date: Date.tomorrow.next_day(30))]
      end
    end

    trait :single_day do
      after(:build) do |event|
        event.date_ranges = []
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.tomorrow.next_day(1), end_date: Date.tomorrow.next_day(1))
      end
    end

    trait :over_six_days do
      after(:build) do |event|
        event.date_ranges = [
          FactoryGirl.create(:date_range, start_date: Date.current.next_day(1), end_date: Date.current.next_day(6))
        ]
      end
    end

    trait :with_multiple_date_ranges do
      after(:build) do |event|
        event.date_ranges = []
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.current.next_day(3), end_date: Date.tomorrow.next_day(5))
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.current.next_day(12), end_date: Date.current.next_day(16))
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.current.next_day(1), end_date: Date.current.next_day(2))
      end
    end

    trait :with_unreasonably_long_range do
      after(:build) do |event|
        event.date_ranges << FactoryGirl.create(:date_range,
          start_date: Date.tomorrow,
          end_date: Date.tomorrow.next_day(Rails.configuration.unreasonably_long_event_time_span) + 8)
      end
    end

    trait :without_date_ranges do
      date_ranges { [] }
    end


    trait :with_diverse_open_applications do
      after(:build) do |event, evaluator|
        create_list(:application_letter, 2, event: event)
        event.application_letters[0].user.profile = FactoryGirl.build :profile, :high_values, user: event.application_letters[0].user
        event.application_letters[1].user.profile = FactoryGirl.build :profile, :low_values, user: event.application_letters[1].user
      end
    end

    trait :in_draft_phase do
      after(:build) do |event|
        event.published = false
      end
    end

    trait :in_application_phase do
      after(:build) do |event|
        event.published = true
        event.application_deadline = Date.tomorrow
      end
    end

    trait :in_selection_phase do
      after(:build) do |event|
        event.published = true
        event.application_deadline = Date.yesterday
        event.application_status_locked = false
      end
    end

    trait :in_execution_phase do
      after(:build) do |event|
        event.published = true
        event.application_deadline = Date.yesterday
        event.application_status_locked = true
      end
    end

    factory :event_with_accepted_applications do
      name "Event-Name"
      description "Event-Description"
      max_participants 20
      date_ranges { build_list :date_range, 1 }
      hidden false
      transient do
        accepted_application_letters_count 5
        rejected_application_letters_count 5
      end
      organizer "Workshop-Organizer"
      knowledge_level "Workshop-Knowledge Level"
      application_deadline Date.current
      
      after(:create) do |event, evaluator|
        create_list(:application_letter_accepted, evaluator.accepted_application_letters_count, event: event)
        create_list(:application_letter_rejected, evaluator.rejected_application_letters_count, event: event)
      end

      factory :event_with_accepted_applications_and_agreement_letters do
        after(:create) do |event, evaluator|
          create_list(:accepted_application_with_agreement_letters, evaluator.accepted_application_letters_count, event: event)
        end
      end

    end
  end
end
