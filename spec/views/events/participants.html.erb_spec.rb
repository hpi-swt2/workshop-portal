require 'rails_helper'

RSpec.describe "events/participants", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event_with_accepted_applications))
	@participants = assign(:participants, @event.participants)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text("Einverständniserklärung")
    expect(rendered).to have_text(@event.participants[0].name)
  end
end
