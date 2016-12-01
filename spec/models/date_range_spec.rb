require 'rails_helper'

describe DateRange do
  let(:event) {FactoryGirl.create :event }
  let(:date_range) { FactoryGirl.create :date_range, event_id: event.id }

  it "has a foreign key for an Event" do
    expect(date_range.event_id).to eq(event.id)
  end

  it "does not validate with dateRanges in the past" do
    pastDates = FactoryGirl.build(:date_range, :with_past_dates)
    expect(pastDates).to_not be_valid
  end

  it "should not have a negative range" do
    negativeDates = FactoryGirl.build(:date_range, :with_negative_range)
    expect(negativeDates).to_not be_valid
  end
end
