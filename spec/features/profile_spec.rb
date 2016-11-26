require "rails_helper"

RSpec.feature "Upload letter of agreement", :type => :feature do
  before :each do
    @user = FactoryGirl.create(:user, role: :pupil)
    @user.profile ||= FactoryGirl.create(:profile)
    login_as(@user, scope: :user)
    visit profile_path(@user.profile)
  end
  scenario "user uploads letter of agreement for the first time" do
    attach_file(:letter_upload, './spec/testfiles/actual.pdf')
    click_button :upload_btn
    expect(page).to have_current_path profile_path(@user.profile)
  end

  scenario "user uploads a file with the wrong extension" do
    attach_file(:letter_upload, './spec/testfiles/not_a_pd.f')
    click_button :upload_btn
    expect(page).to have_text(I18n.t("agreement_letters.wrong_filetype"))
  end

  scenario "user uploads a file that is too big" do
    stub_const("AgreementLettersController::MAX_SIZE", 5)
    attach_file(:letter_upload, './spec/testfiles/actual.pdf')
    click_button :upload_btn
    expect(page).to have_text(I18n.t("agreement_letters.file_too_big"))
  end

  #scenario "user upload fails" do
    #ObjectSpace.each_object(AgreementLetter) { |o| o.readonly! }
    #attach_file(:letter_upload, './spec/testfiles/actual.pdf')
    #click_button :upload_btn
    #expect(page).to have_text(I18n.t("agreement_letters.upload_failed"))
  #end
end

RSpec.feature "Profile adaptation", :type => :feature do
  scenario "user leaves out required fields" do
    @profile = FactoryGirl.create(:profile)
    login_as(@profile.user, :scope => :user)
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
