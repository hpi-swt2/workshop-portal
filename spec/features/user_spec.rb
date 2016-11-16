require "rails_helper"

# https://www.relishapp.com/rspec/rspec-rails/v/3-5/docs/feature-specs/feature-spec
RSpec.feature "Account creation", :type => :feature do
  scenario "User visits for the first time and creates an account" do
    # Look at the output of the 'rake routes' command
    visit new_user_registration_path

    password = "mybirthdate"
    # http://www.rubydoc.info/github/jnicklas/capybara/Capybara/Node/Actions:fill_in
    fill_in "user_email", :with => "first.last@example.com"
    fill_in "user_name", :with => "First Last"
    fill_in "user_password", :with => password
    fill_in "user_password_confirmation", :with => password
    # http://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FNode%2FFinders%3Afind
    find('input[name="commit"]').click

    # Show success alert
    # http://www.rubydoc.info/github/jnicklas/capybara/master/Capybara/RSpecMatchers#have_css-instance_method
    expect(page).to have_css(".alert-success")

    # Make sure the user has the pupil role after registration.
    user = User.find_by_name('First Last')
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

  scenario "User changes name on user settings page" do
    user = FactoryGirl.create(:user)
    login_as(user)
    new_name = "xXACoolAliasXx"

    # Go to /users/edit
    visit edit_user_registration_path
    fill_in "user_name", :with => new_name
    fill_in "user_current_password", :with => user.password
    find('input[name="commit"]').click
    expect(page).to have_css(".alert-success")

    visit edit_user_registration_path
    expect(page).to have_content(new_name)
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