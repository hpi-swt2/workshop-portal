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

  scenario "logged in as Organizer can change application status with radio buttons" do
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = :organizer
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)

    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    ApplicationLetter.statuses.keys.each do |new_status|
      choose(I18n.t "application_status.#{new_status}")
      ApplicationLetter.where(id: @application_letter.id, status: new_status)
    end
  end

  scenario "logged in as Coach can see application status" do
    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = :tutor
    login_as(@profile.user, :scope => :user)
    visit event_path(@event)

    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "application_status.#{@application_letter.status}")
  end

end
