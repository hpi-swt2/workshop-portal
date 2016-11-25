require 'rails_helper'

describe DateRange do
	it "belongs to an Event" do
		event = create(:event)  #FIXME this will later need to be renamed create(:event)
		visit event_path(event)
		expect(event.date_range.size).to eq(1)
	end
end
