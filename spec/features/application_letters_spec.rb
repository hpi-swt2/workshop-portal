require "rails_helper"

RSpec.feature "Application Letter Overview", :type => :feature do
  scenario "logged in as Pupil I cannot see notes" do
    login(:pupil)
    expect(page).to_not have_css("textarea#application_note_note")
    @application_letter.application_notes.each do | note |
      expect(page).to_not have_text(note.note)
    end
  end

  %i[coach organizer].each do |role|
    scenario "logged in as #{role} I can see notes" do
      login(role)
      expect(page).to have_css("textarea#application_note_note")
      @application_letter.application_notes.each do | note |
        expect(page).to have_text(note.note)
      end
    end

    scenario "logged in as #{role} I can create new notes" do
      login(role)
      fill_in("application_note_note", with: "Hate him! Hate him!")
      click_button I18n.t "helpers.titles.new", model: ApplicationNote.model_name.human
      expect(page).to have_text("Hate him! Hate him!")
    end
  end

  it "should highlight wrong or missing insertions from user" do
    login(:pupil)
    visit new_application_letter_path
    fill_in "application_letter_experience", with:   ""
    fill_in "application_letter_motivation", with:   ""
    fill_in "application_letter_coding_skills", with:   ""
    fill_in "application_letter_emergency_number", with:   ""

    find('input[name=commit]').click

    expect(page).to have_css(".has-error", count: 12)
  end

   it "should save" do
    login(:pupil)
    visit new_application_letter_path(:event_id => @event.id)
    select "11", from: "application_letter_grade"
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

  %i[pupil coach].each do |role|
    it "shows an error if the site of another application letter is accessed by url" do
      user = FactoryGirl.create(:user, role: role)
      another_user = FactoryGirl.create(:user)
      another_application = FactoryGirl.create(:application_letter, user: another_user)

      visit application_letter_path(id: another_application.id)

      expect(page).to have_text(I18n.t('unauthorized.manage.all'))
    end
  end

  it "shows an error if you aren't logged in" do
    profile = FactoryGirl.create(:profile)
    event = FactoryGirl.create(:event)
    user = profile.user
    login_error_message = I18n.t 'application_letters.login_before_creation'
    login_link_text = I18n.t 'users.sessions.new.sign_in'
    new_application_path = new_application_letter_path(:event_id => event.id)

    visit new_application_path
    page.assert_current_path new_application_path # Make sure no redirect happened
    expect(page).to have_text login_error_message
    link = page.find('main').find(:link, login_link_text)
    link.click

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[name=commit]').click

    page.assert_current_path(new_application_path)
    expect(page).to_not have_text login_error_message
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
