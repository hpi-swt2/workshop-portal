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

  scenario "Emails can not be send if there is any unclassified application left" do
    login(:organizer)
    expect(page).to have_button("Zusagen verschicken", disabled: true)
    expect(page).to have_button("Absagen verschicken", disabled: true)
  end

  scenario "Emails can not be send if there is a negative number of free places left" do
    login(:organizer)
    page.choose("Accept")
    expect(page).to have_button("Zusagen verschicken", disabled: true)
    expect(page).to have_button("Absagen verschicken", disabled: true)
  end

  scenario "Clicking on sending emails button opens a modal" do
    login(:organizer)
    page.choose("Accept")
    expect(page).to have_button("Zusagen verschicken", disabled: false)
    expect(page).to have_button("Absagen verschicken", disabled: false)
  end


  def login(role)
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)
  end
end