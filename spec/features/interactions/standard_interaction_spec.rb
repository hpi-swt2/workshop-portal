require 'rails_helper'

RSpec::Steps.steps "Demo" do
  it "should show the global title" do
    visit root_path
    page.should have_text "Workshop"
  end
end

def login(email, password)
  click_link I18n.t('navbar.login')
  fill_in 'login_email', with: email
  fill_in 'login_password', with: password
end

def sign_up(email, password)
  click_link I18n.t('navbar.login')
  fill_in 'sign_up_email', with: email
  fill_in 'sign_up_password', with: password
  fill_in 'sign_up_password_confirmation', with: password
end