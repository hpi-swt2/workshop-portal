require "rails_helper"

describe "Event", type: :feature do
  describe "index page" do
    it "should link to the show page when an event title is clicked" do
      event = FactoryGirl.create :event
      visit events_path
      click_link event.name
      expect(page).to have_current_path(event_path(event))
    end
  end

  describe "create page" do
    ['Camp', 'Workshop'].each do |kind|
      it "should allow picking the #{kind} kind camp" do
        visit new_event_path
        fill_in "Maximale Teilnehmerzahl", :with => 25
        choose(kind)
        click_button I18n.t('.events.form.publish')
        expect(page).to have_text(kind)
      end
    end

    it "should not allow dates in the past" do
      visit new_event_path
      fill_in "event[date_ranges_attributes][][start_date]", with: Date.yesterday.prev_day
      fill_in "event[date_ranges_attributes][][end_date]", with: Date.yesterday
      click_button I18n.t('.events.form.publish')
      expect(page).to have_text("Anfangs-Datum darf nicht in der Vergangenheit liegen.")
    end

    it "should warn about unreasonably long time spans" do
      visit new_event_path
      fill_in 'Maximale Teilnehmerzahl', :with => 25
      fill_in "event_application_deadline", :with => Date.current
      fill_in "event[date_ranges_attributes][][start_date]", with: Date.current
      fill_in "event[date_ranges_attributes][][end_date]", with: Date.current.next_year(3)
      click_button I18n.t('.events.form.publish')
      expect(page).to have_text("End-Datum liegt ungewöhnlich weit vom Start-Datum entfernt.")
    end

    it "should not allow an end date before a start date" do
      visit new_event_path
      fill_in "event[date_ranges_attributes][][start_date]", with: Date.current
      fill_in "event[date_ranges_attributes][][end_date]", with: Date.current.prev_day(2)
      click_button I18n.t('.events.form.publish')

      expect(page).to have_text("End-Datum kann nicht vor Start-Datum liegen")
    end

    it "should allow entering multiple time spans", js: true do
      visit new_event_path

      first_from = Date.tomorrow.next_day(1)
      first_to = Date.tomorrow.next_day(2)

      second_from = Date.tomorrow.next_day(6)
      second_to = Date.tomorrow.next_day(8)

      fill_in 'Maximale Teilnehmerzahl', :with => 25
      fill_in "event[date_ranges_attributes][][start_date]", with: I18n.l(first_from)
      fill_in "event[date_ranges_attributes][][end_date]", with: I18n.l(first_to)

      click_link "Zeitspanne hinzufügen"
      within page.find('#event-date-pickers').all('div')[1] do
        fill_in "event[date_ranges_attributes][][start_date]", with: I18n.l(second_from)
        fill_in "event[date_ranges_attributes][][end_date]", with: I18n.l(second_to)
      end
      fill_in "event_application_deadline", :with => I18n.l(Date.tomorrow)
      click_button I18n.t('.events.form.publish')

      expect(page).to have_text (DateRange.new start_date: first_from, end_date: first_to)
      expect(page).to have_text (DateRange.new start_date: second_from, end_date: second_to)
    end
    it "should save application deadline" do
      visit new_event_path

      deadline = Date.tomorrow
      fill_in "event_name", :with => "Event Name"
      fill_in "event_max_participants", :with => 12
      fill_in "event_application_deadline", :with => I18n.l(deadline)
      fill_in "event[date_ranges_attributes][][start_date]", :with => Date.current.next_day(2)
      fill_in "event[date_ranges_attributes][][end_date]", :with => Date.current.next_day(3)

      click_button I18n.t('.events.form.publish')

      expect(page).to have_text("Bewerbungsschluss: " + I18n.l(deadline))
    end
    it "should not allow an application deadline after the start of the event" do
      visit new_event_path

      fill_in "event_max_participants", :with => 12
      fill_in "event_application_deadline", :with => Date.tomorrow
      fill_in "event[date_ranges_attributes][][start_date]", :with => Date.current

      click_button I18n.t('.events.form.publish')

      expect(page).to have_text("Bewerbungsschluss muss vor Beginn der Veranstaltung liegen")
    end
  end

  describe "show page" do
    it "should display the event kind" do
      %i[camp workshop].each do |kind|
        event = FactoryGirl.create(:event, kind: kind)
        visit event_path(event)
        expect(page).to have_text(kind.to_s.humanize)
      end
    end

    it "should display a single day date range as a single date" do
      event = FactoryGirl.create(:event, :single_day)
      visit event_path(event)
      expect(page).to have_text(event.date_ranges.first.start_date)
      expect(page).to_not have_text(" bis " + I18n.l(event.date_ranges.first.end_date))
    end

    it "should display all date ranges" do
      event = FactoryGirl.create(:event, :with_two_date_ranges)
      visit event_path(event.id)

      expect(page).to have_text(event.date_ranges.first)
      expect(page).to have_text(event.date_ranges.second)
    end

    it "should show that the application deadline is on midnight of the picked date" do 
      event = FactoryGirl.create(:event)
      visit event_path(event.id)
      expect(page).to have_text(I18n.l(event.application_deadline) + " Mitternacht")
    end 
  end

  describe "edit page" do
    it "should preselect the event kind" do
      event = FactoryGirl.create(:event, kind: :camp)
      visit edit_event_path(event)
      expect(find_field('Camp')[:checked]).to_not be_nil
    end

    it "should display all existing date ranges" do
      event = FactoryGirl.create(:event, :with_two_date_ranges)
      visit edit_event_path(event.id)

      page.assert_selector('[name="event[date_ranges_attributes][][start_date]"]', count: 2)
    end

    it "should save edits to the date ranges" do
      event = FactoryGirl.create(:event, :with_two_date_ranges)
      date_start = Date.current.next_year
      date_end = Date.tomorrow.next_year

      visit edit_event_path(event.id)

      within page.find('#event-date-pickers').first('div') do
        fill_in "event[date_ranges_attributes][][start_date]", with: date_start
        fill_in "event[date_ranges_attributes][][end_date]", with: date_end
      end

      click_button I18n.t('.events.form.update')

      expect(page).to have_text (DateRange.new start_date: date_start, end_date: date_end)
    end
  end
end
