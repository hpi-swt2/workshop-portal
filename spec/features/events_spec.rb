require "rails_helper"

RSpec.feature "Event Applicant Overview", :type => :feature do
  scenario "logged in as Pupil I can not see overview" do
    login(:pupil)
    expect(page).to_not have_table("applicants")
    expect(page).to_not have_css("div#free_places")
    expect(page).to_not have_css("div#occupied_places")
  end

  scenario "logged in as Coach I can see overview" do
    login(:coach)
    expect(page).to have_table("applicants")
    expect(page).to have_css("div#free_places")
    expect(page).to have_css("div#occupied_places")
  end

  scenario "logged in as Organizer I can see overview" do
    login(:organizer)
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
    @pupil1 = FactoryGirl.create(:profile)
    @pupil1.user.role = :pupil
    @pupil2 = FactoryGirl.create(:profile)
    @pupil2.user.role = :pupil
    @accepted_application = FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil1.user)
    @accepted_application_2 = FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil2.user)
    visit event_path(@event)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_acceptances'), disabled: true)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_rejections'), disabled: true)
  end

  scenario "logged in as Organizer I want to open a modal by clicking on sending emails" do
    login(:organizer)
    @event.update!(max_participants: 2)
    @pupil1 = FactoryGirl.create(:profile)
    @pupil1.user.role = :pupil
    @pupil2 = FactoryGirl.create(:profile)
    @pupil2.user.role = :pupil
    @accepted_application = FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil1.user)
    @accepted_application_2 = FactoryGirl.create(:application_letter_accepted, :event => @event, :user => @pupil2.user)
    visit event_path(@event)
    click_button I18n.t('events.applicants_overview.sending_acceptances')
    expect(page).to have_selector('div', :id => 'send-emails-modal')
  end

  scenario "logged in as Organizer I can see the correct count of free/occupied places" do
    login(:organizer)
    @event.update!(max_participants: 1)
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

    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    ApplicationLetter.statuses.keys.each do |new_status|
      choose(I18n.t "application_status.#{new_status}")
      expect(ApplicationLetter.where(id: @application_letter.id)).to exist
    end
  end

  scenario "logged in as Coach I can see application status" do
    login(:coach)

    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "application_status.#{@application_letter.status}")
  end

  def login(role)
    @event = FactoryGirl.create(:event, max_participants: 1)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)
  end
end
