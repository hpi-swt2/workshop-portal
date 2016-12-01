# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :event do
    name "Event-Name"
    description "Event-Description"
    max_participants 1
    active false
    organizer "Workshop-Organizer"
    knowledge_level "Workshop-Knowledge Level"
  
    factory :event_with_accepted_applications do
      name "Event-Name"
      description "Event-Description"
      max_participants 20
      active false
      transient do
        application_letters_count 5
      end
      organizer "Workshop-Organizer"
      knowledge_level "Workshop-Knowledge Level"
      
      after(:create) do |event, evaluator|
        create_list(:application_letter_accepted, evaluator.application_letters_count, event: event)
      end
    end
  end
end
