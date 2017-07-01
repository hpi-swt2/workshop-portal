require 'rails_helper'

describe DateRange do
  let(:event) {FactoryGirl.create :event }
  let(:date_range) { FactoryGirl.create :date_range, event_id: event.id }

  it "has a foreign key for an Event" do
    expect(date_range.event_id).to eq(event.id)
  end

  it "validates a date range from the future" do
    future_dates = FactoryGirl.build(:date_range, :with_future_dates)
    expect(future_dates).to be_valid
  end

  it "validates a date range that is now" do
    current_date_range = FactoryGirl.build(:date_range, :which_is_surrounding_today)
    expect(current_date_range).to be_valid
  end

  it "validates a date range from the past" do
    past_dates = FactoryGirl.build(:date_range, :in_the_past)
    expect(past_dates).to be_valid
  end

  it "should not have a negative range" do
    negativeDates = FactoryGirl.build(:date_range, :with_negative_range)
    expect(negativeDates).to_not be_valid
  end

  it "should print only one date if it is on a single day" do
    date_range = FactoryGirl.build :date_range, :on_single_day
    expect(date_range.to_s).to eq(I18n.l(date_range.start_date))
  end
end
