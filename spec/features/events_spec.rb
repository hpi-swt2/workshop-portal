require "rails_helper"

RSpec.feature "Event application letters overview on event page", :type => :feature do
  before :each do
    @event = FactoryGirl.create(:event)
  end

  scenario "logged in as Pupil I can click the apply button on the index page" do
    login(:pupil)
    visit events_path

    click_link 'Bewerben'
    expect(page).to have_current_path(new_application_letter_path(:event_id => @event.id))
  end

  scenario "logged in as Pupil I can click the apply button on the show page" do
    login(:pupil)
    visit event_path(@event)

    click_link 'Bewerben'
    expect(page).to have_current_path(new_application_letter_path(:event_id => @event.id))
  end

  scenario "logged in as Pupil I can not see overview" do
    login(:pupil)
    visit event_path(@event)

    expect(page).to_not have_table("applicants")
    expect(page).to_not have_css("div#free_places")
    expect(page).to_not have_css("div#occupied_places")
  end

  scenario "logged in as Coach I can see overview" do
    login(:coach)
    visit event_path(@event)
    expect(page).to have_table("applicants")
    expect(page).to have_css("div#free_places")
    expect(page).to have_css("div#occupied_places")
  end

  scenario "logged in as Organizer I can see overview" do
    login(:organizer)
    visit event_path(@event)
    expect(page).to have_table("applicants")
    expect(page).to have_css("div#free_places")
    expect(page).to have_css("div#occupied_places")
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is any unclassified application left" do
    @event = FactoryGirl.build(:event, :with_diverse_open_applications, :in_selection_phase)
    login(:organizer)
    @event.update!(max_participants: 1)
    visit event_path(@event)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_acceptances'), disabled: true)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_rejections'), disabled: true)
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is a negative number of free places left" do
    @event = FactoryGirl.create(:event, :in_selection_phase)
    login(:organizer)
    @event.update!(max_participants: 1)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_acceptances'), disabled: true)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_rejections'), disabled: true)
  end

  scenario "logged in as Organizer I want to be able to send an email to all accepted applicants" do
    @event = FactoryGirl.create(:event, :in_selection_phase)
    login(:organizer)
    @event.update!(max_participants: 2)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    click_link I18n.t('events.applicants_overview.sending_acceptances')
    choose(I18n.t('emails.email_form.show_recipients'))
    fill_in('email_subject', with: 'Subject')
    fill_in('email_content', with: 'Content')
    expect{click_button I18n.t('emails.email_form.send')}.to change{ActionMailer::Base.deliveries.count}.by(1)
  end

  scenario "logged in as Organizer I want to be able to send an email to all rejected applicants" do
    @event = FactoryGirl.create(:event, :in_selection_phase)
    login(:organizer)
    @event.update!(max_participants: 2)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter_rejected, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    click_link I18n.t('events.applicants_overview.sending_rejections')
    choose(I18n.t('emails.email_form.show_recipients'))
    fill_in('email_subject', with: 'Subject')
    fill_in('email_content', with: 'Content')
    expect{click_button I18n.t('emails.email_form.send')}.to change{ActionMailer::Base.deliveries.count}.by(1)
  end

  scenario "logged in as Organizer I can see the correct count of free/occupied places" do
    login(:organizer)
    @event.update!(max_participants: 1)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "free_places", count: (@event.max_participants).to_i, scope: [:events, :applicants_overview])
    expect(page).to have_text(I18n.t "occupied_places", count: 0, scope: [:events, :applicants_overview])
    2.times do |i| #2 to also test negative free places, those are fine
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      @application_letter = FactoryGirl.create(:application_letter_accepted, event: @event, user: @pupil.user)
      visit event_path(@event)
      expect(page).to have_text(I18n.t "free_places", count: (@event.max_participants).to_i - (i+1), scope: [:events, :applicants_overview])
      expect(page).to have_text(I18n.t "occupied_places", count: (i+1), scope: [:events, :applicants_overview])
    end
  end

  scenario "logged in as Organizer I can change application status with radio buttons" do
    login(:organizer)
    @event.application_status_locked = false
    @event.save
    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    ApplicationLetter.statuses.keys.each do |new_status|
      choose(I18n.t "application_status.#{new_status}")
      expect(ApplicationLetter.where(id: @application_letter.id)).to exist
    end
  end

  scenario "logged in as Organizer I can change application status with radio buttons without the page reloading", js: true do
    login(:organizer)
    @event.application_status_locked = false
    @event.save
    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    find('label', text: I18n.t('application_status.accepted')).click

    check_values = lambda {
      expect(page).to have_text(I18n.t "free_places", count: (@event.max_participants).to_i - 1, scope: [:events, :applicants_overview])
      expect(page).to have_text(I18n.t "occupied_places", count: 1, scope: [:events, :applicants_overview])
    }

    check_values.call
    # verify that the state was actually persisted by reloading the page
    visit event_path(@event)
    check_values.call
    expect(page).to have_css('label.active', text: I18n.t('application_status.accepted'))
  end

  scenario "logged in as Organizer I can not change application status with radio buttons if the applications are locked" do
    login(:organizer)
    @event.lock_application_status
    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    ApplicationLetter.statuses.keys.each do |new_status|
      if new_status != @application_letter.status
        expect(page).not_to have_text(I18n.t "application_status.#{new_status}")
      end
    end
  end

  scenario "logged in as Organizer I can push the accept all button to accept all applicants" do
    @event = FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase, participants_are_unlimited: true)
    login(:organizer)
    visit event_path(@event)
    click_link I18n.t "events.applicants_overview.accept_all"
    application_letters = ApplicationLetter.where(event: @event.id)
    expect(application_letters.all? { |application_letter| application_letter.status == 'accepted' }).to eq(true)
  end

  scenario "logged in as Organizer and viewing the participants page all checkboxes are checked when pressing the \"check all\" button", js: true do
    login(:organizer)
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user, birth_date: 15.years.ago)
    @event = FactoryGirl.create(:event)
    @application = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    @agreement = FactoryGirl.create(:agreement_letter, user: @user, event: @event)
    visit event_participants_path(@event)
    check 'select_all_participants'
    all('input[type=checkbox]').each do |checkbox|
      expect(checkbox).to be_checked
    end
  end

  scenario "logged in as Organizer when I want to download agreement letters but no participants are selected, it displays error message", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page).to have_text(I18n.t "events.agreement_letters_download.notices.no_participants_selected")
  end

  scenario "logged in as Organizer when I want to download agreement letters but no participants have agreement letters, it displays error message", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    find(:css, "#selected_participants_[value='2']").click
    find("option[value='zip']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page).to have_text(I18n.t "events.agreement_letters_download.notices.no_agreement_letters")
    visit event_participants_path(@event)
    find(:css, "#selected_participants_[value='2']").click
    find("option[value='pdf']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page).to have_text(I18n.t "events.agreement_letters_download.notices.no_agreement_letters")
  end

  scenario "logged in as Organizer when I want to download agreement letters in a zip file, I can do so", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    check 'select_all_participants'
    find("option[value='zip']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page.response_headers['Content-Type']).to eq("application/zip")
  end

  scenario "logged in as Organizer when I want to download agreement letters in a pdf file, I can do so", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    check 'select_all_participants'
    find("option[value='pdf']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page.response_headers['Content-Type']).to eq("application/pdf")
  end

  scenario "logged in as Coach I can see application status" do
    login(:coach)
    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "application_status.#{@application_letter.status}")
  end

  scenario "Logged in as organizer I can see a table with the applicants and sort them by attributes" do
    login(:organizer)
    @event = FactoryGirl.create(:event)
    visit event_path(@event)

    table = page.find(:xpath, '//table[@id="applicants"]')
    @event.application_letters.each do |application_letter|
      expect(table).to have_text(application_letter.user.profile.name)
    end

    ['name', 'gender'].each do |attribute|
      link_name = I18n.t("activerecord.attributes.profile.#{attribute}")
      click_link link_name
      sorted_by_attribute = @event.application_letters.to_a.sort_by { |letter| letter.user.profile.send(attribute) }
      names = sorted_by_attribute.map {|l| l.user.profile.name }
      expect(page).to contain_ordered(names)

      click_link link_name # again
      expect(page).to contain_ordered(names.reverse)
    end

    link_name = I18n.t('events.applicants_overview.age_when_event_starts')
    click_link link_name
    sorted_by_attribute = @event.application_letters.to_a.sort_by { |letter| letter.send(attribute) }
    names = sorted_by_attribute.map {|l| l.user.profile.name }
    expect(page).to contain_ordered(names)

    click_link link_name # again
    expect(page).to contain_ordered(names.reverse)
  end

  scenario "logged in as Organizer I can filter displayed application letters by their status and simultaneously sort them", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications)
    @event.application_letters.each do |letter|
      letter.user.profile = FactoryGirl.build(:profile, user: letter.user)
    end

    visit event_path(@event)
    click_button I18n.t 'events.applicants_overview.filter_by'
    check I18n.t 'application_status.accepted'
    click_button I18n.t 'events.applicants_overview.filter'

    accepted_names = @event.application_letters.to_a.select { |l| l.status.to_sym == :accepted }.map {|l| l.user.profile.name}
    not_accepted_names = @event.application_letters.to_a.select { |l| l.status.to_sym != :accepted }.map {|l| l.user.profile.name}

    expect(page).to have_every_text(accepted_names)
    expect(page).to have_no_text(not_accepted_names)

    # sort this list by name
    click_link I18n.t('activerecord.attributes.profile.name')

    sorted_accepted_names = @event.application_letters
      .to_a
      .sort_by { |letter| letter.user.profile.name }
      .select { |letter| letter.status.to_sym == :accepted }
      .map {|letter| letter.user.profile.name }
    expect(page).to contain_ordered(sorted_accepted_names)

    # list rejected, pending
    click_button I18n.t 'events.applicants_overview.filter_by'
    uncheck I18n.t 'application_status.accepted'
    check I18n.t 'application_status.rejected'
    check I18n.t 'application_status.pending'
    click_button I18n.t 'events.applicants_overview.filter'

    expect(page).to have_every_text(not_accepted_names)
    expect(page).to have_no_text(accepted_names)
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
