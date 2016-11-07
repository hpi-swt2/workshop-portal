require "rails_helper"

RSpec.feature "Account creation", :type => :feature do
  scenario "User visits for the first time and creates an account" do
    visit "/users/sign_up"

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
end