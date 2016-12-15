require "rails_helper"

RSpec.feature "Draft events", :type => :feature do
  before(:each) do
    @event = FactoryGirl.create(:event, draft: nil)

    visit new_event_path
    fill_in "event_name", :with => @event.name
    fill_in "event_description", :with => @event.description
    fill_in "event_max_participants", :with => @event.max_participants
    fill_in "event_application_deadline", :with => @event.application_deadline
    fill_in "event[date_ranges_attributes][][start_date]", with: Date.current.next_day(2)
    fill_in "event[date_ranges_attributes][][end_date]", with: Date.current.next_day(3)
  end

  scenario "User saves a draft event, but doesn't publish it" do
    draft_button.click()

    # Show success alert
    expect(page).to have_css(".alert-success")

    # The event should not be visible in the events list
    visit events_path
    expect(page).to_not have_text(@event.name)
  end

  scenario "User revisits a saved draft event and publishes it" do
    draft_button.click()

    visit edit_event_path(@event)
    publish_button.click()

    expect(page).to have_css(".alert-success")

    # The event should now be visible in the events list
    visit events_path
    expect(page).to have_text(@event.name)
  end
end

def draft_button
  find(:xpath, "//input[contains(@name, 'draft')]")
end

def publish_button
  find(:xpath, "//input[contains(@name, 'publish')]")
end
