require "rails_helper"

RSpec.feature "Event Applicant Overview", :type => :feature do
  scenario "logged in as Pupil can not see overview" do
    login(:pupil)
    expect(page).to_not have_table("applicants")
  end

  scenario "logged in as Coach can see overview" do
    login(:coach)
    expect(page).to have_table("applicants")
  end

  scenario "logged in as Organizer can see overview" do
    login(:organizer)
    expect(page).to have_table("applicants")
  end


  def login(role)
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)
  end
end