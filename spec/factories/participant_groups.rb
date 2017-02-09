FactoryGirl.define do
  factory :participant_group do
    event
    association :user, factory: :user_with_profile
    group 1
  end
end
