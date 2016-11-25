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
#

FactoryGirl.define do
  factory :event do
    name "Event-Name"
    description "Event-Description"
    max_participants 100
    active false

    trait :with_two_date_ranges do
      after (:create) do |event|
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.tomorrow, end_date: Date.tomorrow.next_day(5))
        event.date_ranges << FactoryGirl.create(:date_range, start_date: Date.tomorrow, end_date: Date.tomorrow.next_day(10))
      end
    end

    trait :without_date_ranges do #stub to make context in actual tests more readable
    end
  end
end
