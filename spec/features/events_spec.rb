require "rails_helper"

RSpec.feature "Event Applicant Overview", :type => :feature do
  scenario "logged in as Pupil I can not see overview" do
    login(:pupil)
    expect(page).to_not have_table("applicants")
    expect(page).to_not have_css("div#free_places")
    expect(page).to_not have_css("div#occupied_places")
  end

  scenario "logged in as Coach I can see overview" do
    login(:tutor)
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

  scenario "logged in as Organizer I can see the correct count of free/occupied places" do
    login(:organizer)
    @event.update!(max_participants: 1)
    expect(page).to have_text(I18n.t "free_places", places: @event.max_participants, scope: [:events, :applicants_overview])
    expect(page).to have_text(I18n.t "occupied_places", places: 0, scope: [:events, :applicants_overview])
    @pupil = FactoryGirl.create(:profile)
    @pupil.user.role = :pupil
    @application_letter = FactoryGirl.create(:application_letter_accepted, event: @event, user: @pupil.user)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "free_places", places: @event.max_participants - 1, scope: [:events, :applicants_overview])
    expect(page).to have_text(I18n.t "occupied_places", places: 1, scope: [:events, :applicants_overview])
    # test negative amount of free places
    @pupil = FactoryGirl.create(:profile)
    @pupil.user.role = :pupil
    @application_letter = FactoryGirl.create(:application_letter_accepted, event: @event, user: @pupil.user)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "free_places", places: @event.max_participants - 2, scope: [:events, :applicants_overview])
    expect(page).to have_text(I18n.t "occupied_places", places: 2, scope: [:events, :applicants_overview])
  end

  def login(role)
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)
  end
end