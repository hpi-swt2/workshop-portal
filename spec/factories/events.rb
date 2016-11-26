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
  
  factory :event_with_accepted_applications do
    max_participants 20
    transient do
      accepted_application_letters_count 5
      rejected_application_letters_count 5
    end
    
    after(:create) do |event, evaluator|
      create_list(:accepted_application_letter, evaluator.accepted_application_letters_count, event: event)
      create_list(:rejected_application_letter, evaluator.rejected_application_letters_count, event: event)
    end
  end
  
  end
  
  
end
