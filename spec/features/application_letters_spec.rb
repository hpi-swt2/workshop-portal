require 'rails_helper'

RSpec.feature "ApplicationLetters", type: :feature do
  it "should highlight wrong or missing insertions from user" do
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
   	@application = FactoryGirl.create(:application_letter)
    visit new_application_letter_path
    fill_in "application_letter_grade", with:   "10"
    fill_in "application_letter_experience", with:   "None"
    fill_in "application_letter_motivation", with:   "None"
    fill_in "application_letter_coding_skills", with:   "None"
    fill_in "application_letter_emergency_number", with:   "01234567891"
    check "application_letter_allergic"
    fill_in "application_letter_allergies", with:   "Many"

    find('input[name=commit]').click

    expect(@application).to exist
  end
end
