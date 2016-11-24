require "rails_helper"

RSpec.feature "Upload letter of agreement", :type => :feature do
  scenario "user uploads letter of agreement for the first time" do
    @profile = FactoryGirl.create(:profile)
    visit profile_path(@profile)
    attach_file(:letter_upload, './spec/testfiles/letter_of_agreement.pdf')
    click_button :upload_btn
    expect(page).to have_current_path profile_path(@profile)
  end
end
