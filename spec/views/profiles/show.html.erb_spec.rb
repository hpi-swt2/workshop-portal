require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@profile.cv)
  end

  it "renders the events table" do
    render
    expect(rendered).to have_table("events_table")
  end

  it "renders a row for each of the user's events" do
    @profile.user = FactoryGirl.create(:user)
    20.times do
      event = FactoryGirl.create(:event)
      FactoryGirl.create(:accepted_application_letter, user: @profile.user, event: event)
    end
    event_count = @profile.user.events.count
    render
    expect(rendered).to have_selector('tr', count: event_count + 1) # add 1 for thead
  end
end
