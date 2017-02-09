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

  %i[pupil coach organizer].each do |role|
    scenario "logged in as #{role} I cannot see a delete button" do
      login(role)
      expect(page).to_not have_link(I18n.t "application_letters.show.delete")
    end
  end

  scenario "logged in as admin I can see a delete button" do
    login(:admin)
    expect(page).to have_link(I18n.t "application_letters.show.delete")
  end

  scenario "logged in as pupil I can edit my profile from the checking page" do
    login(:pupil)
    visit check_application_letter_path(@application_letter)
    click_link id: 'edit_profile_link'
    expect(page).to have_current_path(edit_profile_path(@application_letter.user.profile))
  end

  scenario "logged in as pupil I can edit my application from the checking page" do
    login(:pupil)
    visit check_application_letter_path(@application_letter)
    click_link id: 'edit_application_link'
    expect(page).to have_current_path(edit_application_letter_path(@application_letter))
  end

  scenario "when creating an application, the fields contain the data from my last application" do
    login(:pupil)
    second_event = FactoryGirl.create(:event)
    visit new_application_letter_path(:event_id => second_event.id)

    check_filled_field = lambda do |attr|
      expect(page).to have_field(ApplicationLetter.human_attribute_name(attr),
                                 with: @application_letter.send(attr))
    end
    check_checked_checkbox = lambda do |attr|
      expect(page).to have_field(ApplicationLetter.human_attribute_name(attr),
                                 checked: @application_letter.send(attr))
    end

    check_filled_field.call(:emergency_number)
    check_filled_field.call(:organisation)
    check_filled_field.call(:allergies)
    check_checked_checkbox.call(:vegetarian)
    check_checked_checkbox.call(:vegan)
  end

  scenario "when creating my first application, all fields should be empty" do
    login(:pupil)
    ApplicationLetter.where(user: @profile.user).each { |a| a.destroy }
    visit new_application_letter_path(:event_id => @event.id)
    page.all('textarea').each { |input| expect(input.text).to eq "" }
    page.all('input[type=checkbox]').each { |input| expect(input).not_to be_checked }
  end

  it "should highlight wrong or missing insertions from user" do
    login(:pupil)
    visit new_application_letter_path(:event_id => @event.id)
    fill_in "application_letter_motivation", with:   ""
    fill_in "application_letter_emergency_number", with:   ""
    fill_in "application_letter_organisation", with:   ""

    find('input[name=commit]').click

    # each field that errors generates three elements that have the has-error class
    # we are expecting 3 fields to be invalid.
    number_of_errors = 3 * 3
    expect(page).to have_css(".has-error", count: number_of_errors)
  end

  describe "Application creation" do
    it "saves the application with basic attributes" do
      login(:pupil)
      visit new_application_letter_path(:event_id => @event.id)
      fill_in_application
      fill_in "application_letter_motivation", with:   "I am so motivated"
      expect(ApplicationLetter.where(motivation:"I am so motivated")).to_not exist
      find('input[name=commit]').click
      expect(ApplicationLetter.where(motivation:"I am so motivated")).to exist
    end

    it "saves and displays custom fields in the application" do
      login(:pupil)
      visit new_application_letter_path(:event_id => @event.id)
      fill_in_application
      all('#custom_application_fields_').each_with_index do |field, index|
        field.set "value #{index}"
      end
      find('input[name=commit]').click

      @event.custom_application_fields.each_with_index do |field_name, index|
        expect(page).to have_text("#{field_name}: value #{index}")
      end
    end

    it "displays values I entered in custom fields when I edit the application later" do
      letter = FactoryGirl.create(:application_letter)
      login_as(letter.user, :scope => :user)
      visit edit_application_letter_path(letter)

      letter.custom_application_fields.each do |field|
        expect(page).to have_css("input[value='#{field}']")
      end
    end
  end

  %i[pupil coach].each do |role|
    it "shows an error if the site of another application letter is accessed by url" do
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
    new_application_path = new_application_letter_path(:event_id => event.id)

    visit new_application_path
    page.assert_current_path user_session_path # Make sure redirect happened
    expect(page).to have_text login_error_message

    fill_in 'login_email', with: user.email
    fill_in 'login_password', with: user.password
    find('input[id="login_submit"]').click
    page.assert_current_path(new_application_path)
    expect(page).to_not have_text login_error_message
  end

  it "shows an error if you don't have a profile and redirects you to the application page after profile creation, even if you make an error in the process" do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    profile_required_message = I18n.t 'application_letters.fill_in_profile_before_creation'

    login_as(user, :scope => :user)

    visit new_application_letter_path(:event_id => event.id)

    # Fill in profile
    page.assert_current_path new_profile_path
    expect(page).to have_text profile_required_message

    # leave out a required field
    fill_in_profile
    fill_in "profile_birth_date", with: ""
    submit_profile

    # do it again, correctly
    fill_in_profile
    submit_profile

    expect(page).to have_text('Bewerbung erstellen')
  end

  it "shows an error if you don't have an account and redirects you to the account creation page, then the profile creation page and last to the application letter page" do
    event = FactoryGirl.create(:event)
    account_required_message = I18n.t 'application_letters.login_before_creation'
    profile_required_message = I18n.t 'application_letters.fill_in_profile_before_creation'

    visit new_application_letter_path(:event_id => event.id)

    # Redirected to new account creation
    page.assert_current_path new_user_session_path
    expect(page).to have_text account_required_message
    # Create new account
    password = "123456"
    fill_in "sign_up_email", with: "walls@arenotgreat.com"
    fill_in "sign_up_password", with: password
    fill_in "sign_up_password_confirmation", with: password
    find('#sign_up_submit').click

    # Fill in profile
    page.assert_current_path new_profile_path
    expect(page).to have_text profile_required_message
    fill_in_profile
    submit_profile

    expect(page).to have_text('Bewerbung erstellen')
  end

  it "redirects you to the application page after profile update" do
    event = FactoryGirl.create(:event)
    profile = FactoryGirl.create(:profile)
    login_as(profile.user, :scope => :user)
    application_letter = FactoryGirl.create(:application_letter, user: profile.user, event: event)

    visit check_application_letter_path(application_letter)

    click_link id: 'edit_profile_link'

    fill_in "profile_last_name", with: "Doe"

    find('input[name=commit]').click

    expect(page).to have_text I18n.t('application_letters.check.my_application')

  end

  %i[coach organizer].each do |role|
    it "logged in as #{role} I cannot see personal details" do
      login(role)
      expect(page).to_not have_text(@application_letter.user.profile.address)
      expect(page).to_not have_text(@application_letter.organisation)
    end
  end

  it "logged in as admin I can see personal details" do
    login(:admin)
    expect(page).to have_text(@application_letter.user.profile.address)
  end

  it "logged in as admin I cannot see the organiation of an applicant" do
    login(:admin)
    expect(page).to_not have_text(@application_letter.organisation)
  end

  %i[organizer admin].each do |role|
    it "logged in as #{role} I can click on the applicants name" do
      login(role)
      expect(page).to have_link(@application_letter.user.profile.name, :href => profile_path(@application_letter.user.profile))
    end
  end

  it "should only show neccessary fields for hidden events application page" do
    login(:pupil)
    visit new_application_letter_path(@application_letter, :hidden => true)
    ['motivation', 'emergency_number', 'experience'].each do |attr|
      expect(page).to_not have_text(I18n.t('activerecord.attributes.application_letter.'+ attr))
    end
  end
  private

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

  def fill_in_application
    fill_in "application_letter_motivation", with:   "None"
    fill_in "application_letter_emergency_number", with:   "0123456789"
    fill_in "application_letter_organisation", with: "Schule am Griebnitzsee"
    fill_in "application_letter_allergies", with:   "Many"
    fill_in "application_letter_annotation", with:   "Some"
  end

  def fill_in_profile
    fill_in "profile_first_name", with: "John"
    fill_in "profile_last_name", with: "Doe"
    fill_in "profile_birth_date", with: "19.03.2016"
    fill_in "profile_street_name", with: "Rudolf-Breitscheid-Str. 52"
    fill_in "profile_zip_code", with: "14482"
    fill_in "profile_city", with: "Potsdam"
    fill_in "profile_state", with: "Babelsberg"
    fill_in "profile_country", with: "Deutschland"
  end

  def submit_profile
    find('input[name=commit]').click
  end
end
