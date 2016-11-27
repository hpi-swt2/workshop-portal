require "rails_helper"

RSpec.feature "Application Letter Overview", :type => :feature do
  scenario "logged in as Pupil I cannot see notes" do
    login(:pupil)
    expect(page).to_not have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to_not have_text(note)
    end
  end

  scenario "logged in as Coach I can see notes" do
    login(:tutor)
    expect(page).to have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to have_text(note)
    end
  end

  scenario "logged in as Organizer I can see notes" do
    login(:organizer)
    expect(page).to have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to have_text(note)
    end
  end


  def login(role)

    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    @application_letter = FactoryGirl.create(:application_letter, user: @profile.user, event: @event)
    visit application_letter_path(@application_letter)
  end
end