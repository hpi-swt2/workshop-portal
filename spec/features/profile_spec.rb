require "rails_helper"

RSpec.feature "Profile adaptation", :type => :feature do
  scenario "user leaves out required fields" do
    @profile = FactoryGirl.create(:profile)
    visit edit_profile_path(@profile)
    fill_in "profile_first_name", with:   ""
    fill_in "profile_last_name", with:   "Doe"
    fill_in "profile_gender", with:   "männlich"
    fill_in "profile_birth_date", with: ""
    fill_in "profile_email", with:   "karl@doe.com"
    fill_in "profile_school", with: ""
    fill_in "profile_street_name", with:   "Rudolf-Breitscheid-Str. 52"
    fill_in "profile_zip_code", with:   "14482"
    fill_in "profile_city" , with:  "Potsdam"
    fill_in "profile_state" , with:  "Babelsberg"
    fill_in "profile_country" , with:  "Deutschland"


    find('input[name=commit]').click

    expect(page).to have_css(".has-error", count: 3)

  end

end