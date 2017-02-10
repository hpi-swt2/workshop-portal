require "rails_helper"

describe "Event", type: :feature do
  describe "index page" do
    it "should link to the show page when an event's read more button is clicked" do
      event = FactoryGirl.create :event
      visit events_path
      click_link event.name
      expect(page).to have_current_path(event_path(event))
    end

    it "should have a link to an event archive" do
      visit events_path
      expect(page).to have_link(href: events_archive_path)
    end

    it "should not list past events" do
      current_event = FactoryGirl.create :event
      past_event = FactoryGirl.create :event, :in_the_past_valid

      visit events_path
      expect(page).to have_text(current_event.name)
      expect(page).to_not have_text(past_event.name)
    end

    it "should mark an event as draft by showing a label" do
      login_as(FactoryGirl.create(:user, role: :organizer), :scope => :user)

      FactoryGirl.create :event, published: false
      visit events_path
      expect(page).to have_css(".label", text: I18n.t(".activerecord.attributes.event.draft"))
    end

    it "should mark an event as hidden by showing a label" do
      login_as(FactoryGirl.create(:user, role: :organizer), :scope => :user)

      FactoryGirl.create :event, hidden: true
      visit events_path
      expect(page).to have_css(".label", text: I18n.t(".activerecord.attributes.event.hidden"))
    end

    it "should not show drafts to pupils or coaches" do
      %i[coach pupil].each do |role|
        login_as(FactoryGirl.create(:user, role: role), :scope => :user)

        FactoryGirl.create :event, published: false
        visit events_path
        expect(page).to_not have_css(".label", text: I18n.t(".activerecord.attributes.event.draft"))
      end
    end

    it "should not show hidden events to pupils or coaches" do
      %i[coach pupil].each do |role|
        login_as(FactoryGirl.create(:user, role: role), :scope => :user)

        FactoryGirl.create :event, hidden: true, name: "Verstecktes Event"
        visit events_path
        expect(page).to_not have_text("Verstecktes Event")
      end
    end

    it "should display the duration of the event" do
      FactoryGirl.create :event, :over_six_days
      visit events_path
      expect(page).to have_text(I18n.t("events.notices.time_span_consecutive", count: 6))
    end

    it "should display the duration of a sigle day event" do
      FactoryGirl.create :event, :single_day
      visit events_path
      expect(page).to have_text(I18n.t("events.notices.time_span_consecutive", count: 1))
    end

    it "should display note of non consecutive date ranges" do
      FactoryGirl.create :event, :with_multiple_date_ranges
      visit events_path
      expect(page).to have_text(I18n.t("events.notices.time_span_non_consecutive", count: 16))
    end

    it "should display note of today's deadline" do
      FactoryGirl.create :event, :is_only_today
      visit events_path
      expect(page).to have_text(I18n.t("events.notices.deadline_approaching", count: 0))
    end

    it "should display the days left to apply" do
      FactoryGirl.create :event
      visit events_path
      expect(page).to have_text(I18n.t("events.notices.deadline_approaching", count: 1))
    end

    it "should not display the days left to apply if it's more than 7" do
      FactoryGirl.create :event, :application_deadline_in_10_days
      visit events_path
      expect(page).to_not have_text(I18n.t("events.notices.deadline_approaching", count: 10))
    end

    it "should strip markdown from the description" do
      FactoryGirl.create :event, description: "# Headline Test\nParagraph with a [link](http://portal.edu)."
      visit events_path
      expect(page).to_not have_css('h1', text: 'Headline Test')
      expect(page).to_not have_text('Headline Test')
      expect(page).to have_text('Paragraph with a link.')
    end

    it "should truncate the description text if it's long" do
      FactoryGirl.create :event, description: ('a' * Event::TRUNCATE_DESCRIPTION_TEXT_LENGTH) + 'blah'
      visit events_path
      expect(page).to_not have_text('blah')
    end
  end

  describe "archive page" do
    it "should list past events" do
      current_event = FactoryGirl.create :event
      past_event = FactoryGirl.create :event, :in_the_past_valid

      visit events_archive_path
      expect(page).to have_text(past_event.name)
      expect(page).to_not have_text(current_event.name)
    end
  end

  describe "create page" do
    I18n.t(".events.type").each do |type|
      it "should allow picking the #{type[1]} type" do
        visit new_event_path
        fill_in "Maximale Teilnehmerzahl", :with => 25
        choose(type[1])
        click_button I18n.t('.events.form.create')
        expect(page).to have_text(type[1])
      end
    end

    it "should not allow dates in the past" do
      visit new_event_path
      fill_in "event[date_ranges_attributes][][start_date]", with: Date.yesterday.prev_day
      fill_in "event[date_ranges_attributes][][end_date]", with: Date.yesterday
      click_button I18n.t('.events.form.create')
      expect(page).to have_text('Anfangs-Datum darf nicht in der Vergangenheit liegen')
    end

    it "should not allow an end date before a start date" do
      visit new_event_path
      fill_in "event[date_ranges_attributes][][start_date]", with: Date.current
      fill_in "event[date_ranges_attributes][][end_date]", with: Date.current.prev_day(2)
      click_button I18n.t('.events.form.create')

      expect(page).to have_text('End-Datum kann nicht vor Start-Datum liegen')
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
      click_button I18n.t('.events.form.create')

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

      click_button I18n.t('.events.form.create')

      expect(page).to have_text("Bewerbungsschluss " + I18n.l(deadline))
    end
    it "should not allow an application deadline after the start of the event" do
      visit new_event_path

      fill_in "event_max_participants", :with => 12
      fill_in "event_application_deadline", :with => Date.tomorrow
      fill_in "event[date_ranges_attributes][][start_date]", :with => Date.current

      click_button I18n.t('.events.form.create')

      expect(page).to have_text("Bewerbungsschluss muss vor Beginn der Veranstaltung liegen")
    end

    it "should not display errors on date ranges twice", js: true do
      visit new_event_path

      fill_in "Maximale Teilnehmerzahl", :with => 25

      within page.find("#event-date-pickers").all("div")[0] do
        fill_in "event[date_ranges_attributes][][start_date]", with: I18n.l(Date.current.prev_day(7))
        fill_in "event[date_ranges_attributes][][end_date]", with: I18n.l(Date.yesterday.prev_day(7))
      end

      click_link "Zeitspanne hinzufügen"

      within page.find("#event-date-pickers").all("div")[1] do
        fill_in "event[date_ranges_attributes][][start_date]", with: I18n.l(Date.current)
        fill_in "event[date_ranges_attributes][][end_date]", with: I18n.l(Date.yesterday)
      end

      click_button I18n.t(".events.form.create")

      expect(page).to have_css("div.has-error")
      expect(page).to have_content("kann nicht vor Start-Datum liegen", count: 1)
    end

    it "should allow to add custom fields", js: true do
      login_as(FactoryGirl.create(:user, role: :organizer), :scope => :user)

      visit new_event_path

      click_link I18n.t "events.form.add_field"
      within page.find("#custom-application-fields").all(".input-group")[0] do
        fill_in "event[custom_application_fields][]", with: "Lieblingsfarbe"
      end

      click_link I18n.t "events.form.add_field"
      within page.find("#custom-application-fields").all(".input-group")[1] do
        fill_in "event[custom_application_fields][]", with: "Lieblings 'Friends' Charakter"
      end

      fill_in "Maximale Teilnehmerzahl", :with => 25
      fill_in "event[date_ranges_attributes][][start_date]", :with => I18n.l(Date.tomorrow.next_day(2))
      fill_in "event[date_ranges_attributes][][end_date]", :with => I18n.l(Date.tomorrow.next_day(3))
      fill_in "event_application_deadline", :with => I18n.l(Date.tomorrow)

      click_button I18n.t(".events.form.create")

      expect(page).to have_text("Lieblingsfarbe")
      expect(page).to have_text("Lieblings 'Friends' Charakter")
    end

    it "should not allow adding fields after event creation" do
      event = FactoryGirl.create(:event)
      visit edit_event_path(event)
      expect(page).to_not have_text(I18n.t "events.form.add_field")
    end
  end

  describe "show page" do
    it "should render markdown for the description" do
      event = FactoryGirl.create(:event, description: "# Test Headline")
      visit event_path(event)
      expect(page).to have_css("h1", text: "Test Headline")
    end

    it "should display a single day date range as a single date" do
      event = FactoryGirl.create(:event, :single_day)
      visit event_path(event)
      expect(page).to have_text(I18n.l(event.date_ranges.first.start_date))
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
    it "should preselect the event type" do
      event = FactoryGirl.create(:event, hidden: false)
      visit edit_event_path(event)
      expect(find_field(I18n.t("events.type.public"))[:checked]).to_not be_nil
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

  describe "printing badges" do
    before :each do
      login_as(FactoryGirl.create(:user, role: :organizer), :scope => :user)
      @event = FactoryGirl.create(:event)
      @users = 12.times.collect do
        user = FactoryGirl.create(:user_with_profile)
        FactoryGirl.create(:application_letter_accepted, user: user, event: @event)
        user
      end
      visit badges_event_path(@event)
    end

    it "creates a pdf with the selected names" do
      @users.each do |u|
        find(:css, "#selected_ids_[value='#{u.id}']").set(true) if u.id.even?
      end
      select(I18n.t('events.badges.full_name'))
      click_button I18n.t('events.badges.print')
      strings = PDF::Inspector::Text.analyze(page.body).strings
      @users.each do |u|
        if u.id.even?
          expect(strings).to include(u.profile.name)
        else
          expect(strings).not_to include(u.profile.name)
        end
      end
    end

    it "uses the correct name format" do
      all(:css, "#selected_ids_").each { |check| check.set(true) }
      select(I18n.t('events.badges.last_name'))
      click_button I18n.t('events.badges.print')
      strings = PDF::Inspector::Text.analyze(page.body).strings
      @users.each do |u|
        expect(strings).to include(u.profile.last_name)
        expect(strings).not_to include(u.profile.first_name)
      end
    end

    it "selects all participants when the 'select all' checkbox is checked", js: true do
      check('select-all-print')
      all('input[type=checkbox].selected_ids').each { |checkbox| expect(checkbox).to be_checked }
      uncheck('select-all-print')
      all('input[type=checkbox].selected_ids').each { |checkbox| expect(checkbox).not_to be_checked }
    end

    it "creates a pdf with the correct schools" do
      all(:css, "#selected_ids_").each { |check| check.set(true) }
      check('show_organisation')
      click_button I18n.t('events.badges.print')
      strings = PDF::Inspector::Text.analyze(page.body).strings
      @users.each { |u| expect(strings).to include(ApplicationLetter.where(event: @event, user: u).first.organisation) }
    end

    it "does not horribly crash and burn when colors are selected" do
      #testing if the actual colors are used is kinda hard
      all(:css, "#selected_ids_").each { |check| check.set(true) }
      check('show_color')
      click_button I18n.t('events.badges.print')
    end

    it "does not throw an error with a logo" do
      attach_file(:logo_upload, './spec/testfiles/actual.jpg')
      all(:css, "#selected_ids_").each { |check| check.set(true) }
      click_button I18n.t('events.badges.print')
    end

    it "shows an error message if logo is wrong filetype" do
      attach_file(:logo_upload, './spec/testfiles/fake.jpg')
      all(:css, "#selected_ids_").each { |check| check.set(true) }
      click_button I18n.t('events.badges.print')
      expect(page).to have_current_path(badges_event_path(@event))
      expect(page).to have_text(I18n.t('events.badges.wrong_file_format'))
    end

    it "shows an error message if no participant was selected" do
      all(:css, "#selected_ids_").each { |check| check.set(false) }
      click_button I18n.t('events.badges.print')
      expect(page).to have_current_path(badges_event_path(@event))
      expect(page).to have_text(I18n.t('events.badges.no_users_selected'))
    end
  end
end
