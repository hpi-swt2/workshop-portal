require 'rails-helper'

describe EventRange do
	it "belongs to an Event" do
		event = create(:workshop)  #FIXME this will later need to be renamed create(:event)
		visit workshop_path(event)
		expect(event.dateRange.size).to eq(1)
	end
end
