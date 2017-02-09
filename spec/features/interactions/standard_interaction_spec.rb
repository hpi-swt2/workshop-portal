require 'rails_helper'
require './db/sample_data/users'
require './db/sample_data'

RSpec::Steps.steps "Demo" do
  before(:all) do
    Rails.application.load_seed
    add_sample_data
  end

  it "should show the welcome page on startup" do
    visit root_path
    expect(page).to have_text I18n.t('start_page.welcome_to')
  end

  it 'should let an organizer log in' do
    #TODO: Use id instead of visible string, currently id is missing for login button
    click_link I18n.t('navbar.login')
    login_with_credentials(user_organizer.email, user_password)
    expect(page).to_not have_text I18n.t('devise.failure.inactive')
    expect(page).to_not have_text I18n.t('devise.failure.invalid')
    expect(page).to_not have_text I18n.t('devise.failure.not_found_in_database')
    expect(page).to_not have_text I18n.t('devise.failure.locked')
    expect(page).to have_text I18n.t('devise.sessions.signed_in')
  end

  it 'should let organizer click the new event button' do
    click_link I18n.t('navbar.events')
    click_link 'new_event'
  end

  it 'should let organizer fill out event creation page', js: true do
    choose I18n.t "events.type.public"
    choose I18n.t "events.form.draft.publish"
    fill_in 'event_name', with: 'BwInf-Camp'
    fill_in 'description', with: '[von hpi website geklaut]'
    fill_in 'event_max_participants', with: 25
    fill_in "event[date_ranges_attributes][][start_date]", with: I18n.l(Date.new(2019, 01, 20))
    fill_in "event[date_ranges_attributes][][end_date]", with: I18n.l(Date.new(2019, 01, 22))
    fill_in 'event_organizer', with: 'HPI Schülerklub'
    fill_in 'event_knowledge_level', with: 'Fortgeschrittene'
    fill_in 'event_application_deadline', with: I18n.l(Date.new(2019, 01, 12))
    #TODO: Add custom variable application fields
    click_button 'create_event'
    expect(page).to_not have_text I18n.t('errors.form_invalid.one')
    expect(page).to_not have_text I18n.t('errors.form_invalid.other')
  end
end

def logout(displayed_name)
  #TODO: Use id instead of visible string, currently id is missing for dropdown
  click_link displayed_name
  click_link I18n.t('navbar.logout')
end

def login_with_credentials(email, password)
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