require "rails_helper"

RSpec.feature "Draft events", :type => :feature do
  before(:each) do
    @event = FactoryGirl.create(:event)
    @event.draft = nil

    visit new_event_path
    fill_in "event_name", :with => @event.name
    fill_in "event_description", :with => @event.description
    fill_in "event_max_participants", :with => @event.max_participants
    fill_in "event_active", :with => @event.active
  end

  scenario "User saves a draft event, but doesn't publish it" do
    click_button("draft")

    # Show success alert
    expect(page).to have_css(".alert-success")

    # The event should not be visible in the events list
    visit events_path
    expect(page).to_not have_text(@event.name)
  end

  scenario "User revisits a draft event and publishes it" do
    click_button("draft")

    visit edit_event_path(@event)
    click_button("publish")

    expect(page).to have_css(".alert-success")

    # The event should now be visible in the events list
    visit events_path
    expect(page).to have_text(@event.name)
  end
end
