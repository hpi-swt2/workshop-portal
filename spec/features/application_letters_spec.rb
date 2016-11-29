require "rails_helper"

RSpec.feature "Application Letter Overview", :type => :feature do
  scenario "logged in as Pupil I cannot see notes" do
    login(:pupil)
    expect(page).to_not have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to_not have_text(note.note)
    end
  end

  scenario "logged in as Coach I can see notes" do
    login(:coach)
    expect(page).to have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to have_text(note.note)
    end
  end

  scenario "logged in as Organizer I can see notes" do
    login(:organizer)
    expect(page).to have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to have_text(note.note)
    end
  end

  scenario "logged in as Organizer I can create new notes" do
    login(:organizer)
    fill_in("application_note_note", with: "Hate him! Hate him!")
    click_button I18n.t "helpers.titles.new", model: ApplicationNote.model_name.human
    expect(page).to have_text("Hate him! Hate him!")
  end

  scenario "logged in as Coach I can create new notes" do
    login(:coach)
    fill_in("application_note_note", with: "Hate him! Hate him!")
    click_button I18n.t "helpers.titles.new", model: ApplicationNote.model_name.human
    expect(page).to have_text("Hate him! Hate him!")
  end

  def login(role)

    @event = FactoryGirl.create(:event)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
    @application_letter = FactoryGirl.create(:application_letter, user: @profile.user, event: @event)
    @application_note1 = FactoryGirl.create(:application_note, application_letter: @application_letter, note: "This is note 1")
    @application_note2 = FactoryGirl.create(:application_note, application_letter: @application_letter, note: "This is note 2")
    @application_letter.reload
    visit application_letter_path(@application_letter)
  end
end