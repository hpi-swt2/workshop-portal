require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@profile.graduates_school_in)
  end

  it "renders the events table" do
    render
    expect(rendered).to have_table("events_table")
  end

  it "renders a row for each of the user's events" do
    @profile.user = FactoryGirl.create(:user)
    20.times do
      event = FactoryGirl.create(:event)
      FactoryGirl.create(:application_letter_accepted, user: @profile.user, event: event)
    end
    event_count = @profile.user.events.count
    render
    expect(rendered).to have_selector('tr', count: event_count + 1) # add 1 for thead
  end

  it "should show an upload form for an agreement letter for profiles with an age of <18" do
    @profile.user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    letter = FactoryGirl.create(:application_letter_accepted, user: @profile.user, event: event)
    render
    expect(rendered).to have_selector("input[type='file']")
    expect(rendered).to have_selector("input[type='submit']")
  end

  it "should hide the upload form for profiles with an age of 18+" do
    @profile = assign(:profile, FactoryGirl.create(:adult_profile))
    @profile.user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    letter = FactoryGirl.create(:application_letter_accepted, user: @profile.user, event: event)
    render
    expect(rendered).to_not have_selector("input[type='file']")
    expect(rendered).to_not have_selector("input[type='submit']")
  end

  it "renders the events table" do
    render
    expect(rendered).to have_table("events_table")
  end
end
