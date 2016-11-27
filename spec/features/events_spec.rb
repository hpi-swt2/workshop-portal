require "rails_helper"

RSpec.feature "Event Applicant Overview", :type => :feature do
  scenario "logged in as Pupil can not see overview" do
    login(:pupil)
    expect(page).to_not have_table("applicants")
  end

  scenario "logged in as Coach can see overview" do
    login(:tutor)
    expect(page).to have_table("applicants")
  end

  scenario "logged in as Organizer can see overview" do
    login(:organizer)
    expect(page).to have_table("applicants")
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is any unclassified application left" do
    login(:organizer)
    @event.update!(max_participants: 1)
    @pupil1 = FactoryGirl.create(:profile)
    @pupil1.user.role = :pupil
    @nilApplication = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil1.user, :status => nil)
    visit event_path(@event)
    expect(page).to have_button("Zusagen verschicken", disabled: true)
    expect(page).to have_button("Absagen verschicken", disabled: true)
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is a negative number of free places left" do
    login(:organizer)
    @event.update!(max_participants: 1)
    @pupil1 = FactoryGirl.create(:profile)
    @pupil1.user.role = :pupil
    @pupil2 = FactoryGirl.create(:profile)
    @pupil2.user.role = :pupil
    @pupil3 = FactoryGirl.create(:profile)
    @pupil3.user.role = :pupil
    @nilApplication = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil1.user, :status => nil)
    @acceptedApplication = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil1.user, :status => true)
    @acceptedApplication2 = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil2.user, :status => true)
    visit event_path(@event)
    expect(page).to have_button("Zusagen verschicken", disabled: true)
    expect(page).to have_button("Absagen verschicken", disabled: true)
  end

  scenario "logged in as Organizer I want to open a modal by clicking on sending emails" do
    login(:organizer)
    @event.update!(max_participants: 3)
    @pupil1 = FactoryGirl.create(:profile)
    @pupil1.user.role = :pupil
    @pupil2 = FactoryGirl.create(:profile)
    @pupil2.user.role = :pupil
    @acceptedApplication = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil1.user, :status => true)
    @rejectedApplication = FactoryGirl.create(:application_letter, :event => @event, :user => @pupil2.user, :status => false)
    visit event_path(@event)
    click_button "Zusagen verschicken"
    expect(page).to have_selector('div', :id => 'send-emails-modal')
  end


  def login(role)
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)
  end
end