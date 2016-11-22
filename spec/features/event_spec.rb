require "rails_helper"

describe "Event creation", :type => :feature do
  it "should not allow dates in the past" do
    visit new_workshop_path
    fill_in 'event_date_range_start_0', with: '11-11-1997'
    fill_in 'event_date_range_end_0', with: '11-12-1997'
    click_button "Workshop Erstellen"
    expect(page).to have_text("Die Zeitspanne darf nicht in der Vergangenheit liegen")
  end

  it "should not allow unreasonable time spans" do
    visit new_workshop_path
    fill_in 'event_date_range_start_0', with: '11-11-1997'
    fill_in 'event_date_range_end_0', with: '11-12-2007'
    click_button "Workshop Erstellen"
    expect(page).to have_text("Die angegebene Zeitspanne umfasst einen ungewöhnlich langen Zeitraum")
  end

  it "should allow entering multiple time spans" do
    visit new_workshop_path
    fill_in 'event_date_range_start_0', with: '11-11-1997'
    fill_in 'event_date_range_end_0', with: '11-12-1997'
    click_button "Zeitspanne hinzufügen"
    fill_in 'event_date_range_start_1', with: '11-15-1997'
    fill_in 'event_date_range_end_1', with: '11-16-1997'
    click_button "Workshop Erstellen"

    workshop = Workshop.first
    expect(workshop.date_ranges.first.start).to eq('11-11-1997')
    expect(workshop.date_ranges.first.end).to eq('11-12-1997')
    expect(workshop.date_ranges.second.start).to eq('11-15-1997')
    expect(workshop.date_ranges.second.end).to eq('11-16-1997')
  end

  it "should not allow an end date before a start date" do
    visit new_workshop_path
    fill_in 'event_date_range_start_0', with: '11-11-1997'
    fill_in 'event_date_range_end_0', with: '11-10-1997'
    click_button "Workshop Erstellen"

    expect(page).to have_text("End-Datum kann nicht vor Start-Datum liegen")
  end
end

