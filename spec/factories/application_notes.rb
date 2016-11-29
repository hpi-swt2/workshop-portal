FactoryGirl.define do
  factory :application_note do
    note "Hate this guy."
  end
  factory :empty_application_note, class: :application_note do
    note ""
  end
end
