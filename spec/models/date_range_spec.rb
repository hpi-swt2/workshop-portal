require 'rails_helper'

describe DateRange do
  let(:event) {FactoryGirl.create :event }
  let(:dateRange) { FactoryGirl.create :dateRange, event_id: event.id }

	it "has a foreign key for an Event" do
		expect(dateRange.event_id).to eq(event.id)
  end

  it "does not validate with dateRanges in the past" do
    pastDates = build(:dateRange, :with_past_dates)
    expect(pastDates).to_not be_valid
  end

  it "should not have a negative range" do
		negativeDates = build(:dateRange, :with_negative_range)
    expect(negativeDates.to_not be_valid)
  end
end
