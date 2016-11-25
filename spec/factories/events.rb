# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  published         :boolean
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
        event.date_ranges << FactoryGirl.create(:dateRange, start_date: Date.new(2016, 1, 1), end_date: Date.new(2016, 2, 1))
        event.date_ranges << FactoryGirl.create(:dateRange, start_date: Date.new(2017, 1, 1), end_date: Date.new(2017, 2, 1))
      end
    end

    trait :without_date_ranges do
    end
  end
end
