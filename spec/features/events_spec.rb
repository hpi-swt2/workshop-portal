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
    login(:organizer)
    @event.update!(max_participants: 1)
    @pupil = FactoryGirl.create(:profile)
    @pupil.user.role = :pupil
    @pending_application = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil.user)
    visit event_path(@event)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_acceptances'), disabled: true)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_rejections'), disabled: true)
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is a negative number of free places left" do
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

  scenario "logged in as Organizer I want to open a modal by clicking on sending emails" do
    login(:organizer)
    @event.update!(max_participants: 2)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    click_button I18n.t('events.applicants_overview.sending_acceptances')
    expect(page).to have_selector('div', :id => 'send-emails-modal')
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

  scenario "logged in as Organizer I can not change application status with radio buttons if the applications are locked" do
    login(:organizer)
    @event.application_status_locked = true
    @event.save
    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    ApplicationLetter.statuses.keys.each do |new_status|
      if new_status != @application_letter.status
        expect(page).not_to have_text(I18n.t "application_status.#{new_status}")
      end
    end
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

    ['name', 'gender', 'age'].each do |attribute|
      link_name = I18n.t("activerecord.attributes.profile.#{attribute}")
      click_link link_name
      sorted_by_attribute = @event.application_letters.to_a.sort_by { |letter| letter.user.profile.send(attribute) }
      names = sorted_by_attribute.map {|l| l.user.profile.name }
      expect(page).to contain_ordered(names)

      click_link link_name # again
      expect(page).to contain_ordered(names.reverse)
    end
  end

  scenario "logged in as Organizer I can filter displayed application letters by their status", js: true do
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
