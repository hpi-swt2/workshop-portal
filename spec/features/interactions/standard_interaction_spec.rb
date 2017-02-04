require 'rails_helper'
require './db/sample_data/users'

RSpec::Steps.steps "Demo" do
  it "should show the welcome page on startup" do
    visit root_path
    expect(page).to have_text I18n.t('start_page.welcome_to')
  end

  it 'should let an organizer log in' do
    login(user_organizer.email, user_password)
  end
end

def logout(displayed_name)
  click_link displayed_name
  click_link I18n.t('navbar.logout')
end

def login(email, password)
  fill_in 'login_email', with: email
  fill_in 'login_password', with: password
  click_button 'login_submit'
end

def sign_up(email, password)
  fill_in 'sign_up_email', with: email
  fill_in 'sign_up_password', with: password
  fill_in 'sign_up_password_confirmation', with: password
  click_button 'sign_up_submit'
end