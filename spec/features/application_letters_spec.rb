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
    login(:tutor)
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
    login(:tutor)
    fill_in("application_note_note", with: "Hate him! Hate him!")
    click_button I18n.t "helpers.titles.new", model: ApplicationNote.model_name.human
    expect(page).to have_text("Hate him! Hate him!")
  end

  it "should highlight wrong or missing insertions from user" do
		login(:pupil)
    visit new_application_letter_path
    fill_in "application_letter_grade", with:   ""
    fill_in "application_letter_experience", with:   ""
    fill_in "application_letter_motivation", with:   ""
    fill_in "application_letter_coding_skills", with:   ""
    fill_in "application_letter_emergency_number", with:   ""

    find('input[name=commit]').click

    expect(page).to have_css(".has-error", count: 5)
  end

   it "should save" do
		login(:pupil)
    visit new_application_letter_path(:event_id => @event.id)
		fill_in "application_letter_grade", with:   "11"
    fill_in "application_letter_experience", with:   "None"
    fill_in "application_letter_motivation", with:   "None"
    fill_in "application_letter_coding_skills", with:   "None"
    fill_in "application_letter_emergency_number", with:   "0123456789"
    check "application_letter_allergic"
    fill_in "application_letter_allergies", with:   "Many"
    expect(ApplicationLetter.where(grade:"11")).to_not exist
    find('input[name=commit]').click
    expect(ApplicationLetter.where(grade:"11")).to exist
  end



  it "displays help text for motivation textarea" do
    login(:pupil)
    visit new_application_letter_path(:event_id => @event.id, :locale => :de)

    expect(page).to have_text(I18n.t 'application_letters.form.help_text_coding_skills')
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
