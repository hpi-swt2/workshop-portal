require "rails_helper"

# https://www.relishapp.com/rspec/rspec-rails/v/3-5/docs/feature-specs/feature-spec
RSpec.feature "Account creation", :type => :feature do
  scenario "User visits for the first time and creates an account" do
    # Look at the output of the 'rake routes' command
    visit new_user_registration_path

    password = "mybirthdate"
    # http://www.rubydoc.info/github/jnicklas/capybara/Capybara/Node/Actions:fill_in
    fill_in "user_email", :with => "first.last@example.com"
    fill_in "user_password", :with => password
    fill_in "user_password_confirmation", :with => password
    # http://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FNode%2FFinders%3Afind
    find('input[name="commit"]').click

    # Show success alert
    # http://www.rubydoc.info/github/jnicklas/capybara/master/Capybara/RSpecMatchers#have_css-instance_method
    expect(page).to have_css(".alert-success")

    # Make sure the user has the pupil role after registration.
    user = User.find_by_email('first.last@example.com')
    expect(user.role).to eq('pupil')
  end

  scenario "User logs in with valid credentials and is redirected to the index page" do
    user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    find('input[name="commit"]').click
    # Redirected to index page
    expect(page.current_path).to eq(root_path)
    expect(page).to have_css(".alert-success")
  end

  scenario "User changes email on user settings page" do
    user = FactoryGirl.create(:user)
    login_as(user)
    new_mail = "first.last@new_example.com"

    # Go to /users/edit
    visit edit_user_registration_path
    fill_in "email_user_email", :with => new_mail
    fill_in "email_user_current_password", :with => user.password
    find('#email_edit_user input[name="commit"]').click

    expect(page).to have_css(".alert-success")

    visit edit_user_registration_path
    expect(page).to have_content(new_mail)
  end

  scenario "User changes password on user settings page" do
    user = FactoryGirl.create(:user)
    login_as(user)
    new_password = "Barberini"

    # Go to /users/edit
    visit edit_user_registration_path
    fill_in "password_user_password", :with => new_password
    fill_in "password_user_password_confirmation", :with => new_password
    fill_in "password_user_current_password", :with => user.password
    find('#password_edit_user input[name="commit"]').click

    expect(page).to have_css(".alert-success")
  end

  scenario "User has no profile and visits user settings page" do
    user = FactoryGirl.create(:user)
    login_as(user)

    # Go to /users/edit
    visit edit_user_registration_path
    expect(page).to_not have_field("profile_user_profile_first_name")
    find('#create_profile_btn').click

    expect(page).to have_text(I18n.t('helpers.titles.new', :model => Profile.model_name.human.titleize))
  end

  scenario "User changes profile on user settings page" do
    user = FactoryGirl.create(:user_with_profile)
    login_as(user)
    new_name = "Günther"

    # Go to /users/edit
    visit edit_user_registration_path
    fill_in "profile_user_profile_first_name", :with => new_name
    find('#profile_edit_user input[name="commit"]').click

    expect(page).to have_css(".alert-success")
    visit edit_user_registration_path
    expect(page).to have_content(new_name)
  end

  scenario "User changes profile on user settings page but provides invalid data" do
    user = FactoryGirl.create(:user_with_profile)
    login_as(user)

    # Go to /users/edit
    visit edit_user_registration_path
    fill_in "profile_user_profile_first_name", :with => ''
    find('#profile_edit_user input[name="commit"]').click

    expect(page).to have_css(".alert-danger")
  end

  scenario "User visits the 'user settings' page after having already logged off" do
    user = FactoryGirl.create(:user)
    login_as(user)
    logout(:user)

    visit edit_user_registration_path
    # Redirect to sign in page
    expect(page.current_path).to eq(new_user_session_path)

    # http://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FSession%3Asave_and_open_page
    # Save a snapshot of the page and open it in a browser for inspection.
    # save_and_open_page

    # Error message
    expect(page).to have_css('.alert-danger')
  end

end

RSpec.feature "Role management page", :type => :feature do

  %i[pupil coach].each do |role|
    context "as a #{role}" do
      it "shouldn't display the role managment page and show an error" do
        login(role)
        visit users_path
        expect(page).not_to have_text(I18n.t("activerecord.models.user.other"))
        expect(page).to have_text(I18n.t('unauthorized.manage.all'))
      end
    end
  end

  %i[admin organizer].each do |role|
    context "as an #{role}" do
      it "should display the role managment page" do
        login(role)
        visit users_path
        expect(page).to have_text(I18n.t("activerecord.models.user.other"))
      end

      it "can change to role of a user to coach" do
        pupil = FactoryGirl.create(:user)
        login(:admin)
        visit users_path
        expect(page).to have_select('user_role', selected: I18n.t("users.roles.pupil"))
        first('#user_role').find(:xpath, 'option[2]').select_option
        expect(page).to have_select('user_role', selected: I18n.t("users.roles.coach"))
        first('input[value="%s"]' % I18n.t("users.index.save")).click
      end
    end
  end

  context "as an organizer" do
    it "should not display admin role in drop down" do
      login(:organizer)
      visit users_path
      role_options = [I18n.t("users.roles.pupil"),I18n.t("users.roles.coach"),I18n.t("users.roles.organizer")]
      expect(page).to have_select('user_role', options: role_options)
      expect(page).to_not have_select('user_role', options: [I18n.t("users.roles.admin")])
    end
  end

  context "as an admin" do
    it "should display admin role in drop down" do
      login(:admin)
      visit users_path
      role_options = [I18n.t("users.roles.pupil"),I18n.t("users.roles.coach"),I18n.t("users.roles.organizer"),I18n.t("users.roles.admin")]
      expect(page).to have_select('user_role', options: role_options)
    end
  end

  it "can search for users" do
    max1 = FactoryGirl.create(:user)
    max1.profile = FactoryGirl.create(:profile, first_name: "Max")
    max2 = FactoryGirl.create(:user)
    max2.profile = FactoryGirl.create(:profile, first_name: "Max")
    user3 = FactoryGirl.create(:user_with_profile)
    login(:admin)
    visit users_path

    expect(page).to have_text(max1.profile.last_name)
    expect(page).to have_text(max2.profile.last_name)
    expect(page).to have_text(user3.profile.last_name)

    fill_in :search, with: "Max"
    find('#search-button').click

    expect(page).to have_text(max1.profile.last_name)
    expect(page).to have_text(max2.profile.last_name)
    expect(page).to_not have_text(user3.profile.last_name)
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
