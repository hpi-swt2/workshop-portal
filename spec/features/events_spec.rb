require "rails_helper"

RSpec.feature "Event Applicant Overview", :type => :feature do
  scenario "logged in as Pupil can not see overview" do
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = :pupil
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)

    expect(page).to_not have_table("applicants")
  end

  scenario "logged in as Coach can see overview" do
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = :tutor
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)

    expect(page).to have_table("applicants")
  end

  scenario "logged in as Organizer can see overview" do
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = :organizer
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)

    expect(page).to have_table("applicants")
  end

end