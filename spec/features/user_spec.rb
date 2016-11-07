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
  end

  scenario "User visits the 'user settings' page without being logged in" do
    visit edit_user_registration_path
    expect(page.current_path).to eq(new_user_session_path)
    # http://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FSession%3Asave_and_open_page
    # Save a snapshot of the page and open it in a browser for inspection.
    # save_and_open_page
    expect(page).to have_css('.alert-danger')
  end
end