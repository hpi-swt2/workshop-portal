require "rails_helper"

describe "Event creation", :type => :feature do
  it "should not allow dates in the past" do
    visit new_event_path
    select_date_within_selector(Date.yesterday.prev_day, '.event-date-picker-start')
    select_date_within_selector(Date.yesterday, '.event-date-picker-end')
    click_button "Event erstellen"
    expect(page).to have_text("Die Zeitspanne darf nicht in der Vergangenheit liegen")
  end

  it "should not allow unreasonable time spans" do
    visit new_event_path
    select_date_within_selector(Date.today, '.event-date-picker-start')
    select_date_within_selector(Date.today.next_year(3), '.event-date-picker-end')
    click_button "Event erstellen"
    expect(page).to have_text("Die angegebene Zeitspanne umfasst einen ungewöhnlich langen Zeitraum")
  end

  it "should allow entering multiple time spans" do
    visit new_event_path

    first_from = Date.today
    first_to = Date.today.next_day(2)

    second_from = Date.today.next_day(6)
    second_to = Date.today.next_day(8)

    select_date_within_selector(first_from, '.event-date-picker-start')
    select_date_within_selector(first_to, '.event-date-picker-end')
    page.find("#event-add-date-picker").click

    start = page.all('.event-date-picker')[1].find('.event-date-picker-start')
    select_date_within_selector(second_from, start)
    select_date_within_selector(second_to, '.event-date-picker:nth-child(2) .event-date-picker-end')
    click_button "Event erstellen"

    expect(page).to have_text(first_from.to_s + ' bis ' + first_to.to_s)
    expect(page).to have_text(second_from.to_s + ' bis ' + second_to.to_s)
  end

  it "should not allow an end date before a start date" do
    visit new_event_path
    select_date_within_selector(Date.today, '.event-date-picker-start')
    select_date_within_selector(Date.today.prev_day(-2), '.event-date-picker-end')
    click_button "Event erstellen"

    expect(page).to have_text("End-Datum kann nicht vor Start-Datum liegen")
  end
end

