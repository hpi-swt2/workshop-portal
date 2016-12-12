require "rails_helper"

RSpec.feature "Upload letter of agreement", :type => :feature do
  before :each do
    @profile = FactoryGirl.create(:profile)
    @user = FactoryGirl.create(:user, role: :pupil, profile: @profile)
    @event = FactoryGirl.create(:event)
    @application_letter = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    login_as(@user, scope: :user)
    visit profile_path(@user.profile)
  end

  def mock_writing_to_filesystem
    Dir.mktmpdir do |dir|
      tmp_path = File.join(dir, "tmp.pdf")
      allow_any_instance_of(AgreementLetter).to receive(:path).and_return(tmp_path)
      yield
    end
  end

  scenario "user uploads letter of agreement for the first time" do
    mock_writing_to_filesystem do
      attach_file(:letter_upload, './spec/testfiles/actual.pdf')
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_current_path profile_path(@user.profile)
      expect(page).not_to have_css(".alert-danger")
      expect(page).to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.upload_success"))
    end
  end

  scenario "user uploads letter of agreement a second time" do
    mock_writing_to_filesystem do
      attach_file(:letter_upload, './spec/testfiles/actual.pdf')
      click_button "upload_btn_#{@event.id}"
      attach_file(:letter_upload, './spec/testfiles/actual.pdf')
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_current_path profile_path(@user.profile)
      expect(page).not_to have_css(".alert-danger")
      expect(page).to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.upload_success"))
    end
  end

  scenario "user uploads a file with the wrong extension" do
    mock_writing_to_filesystem do
      attach_file(:letter_upload, './spec/testfiles/not_a_pd.f')
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_css(".alert-danger")
      expect(page).not_to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.wrong_filetype"))
    end
  end

  scenario "user uploads a file that is too big" do
    mock_writing_to_filesystem do
      stub_const("AgreementLetter::MAX_SIZE", 5)
      attach_file(:letter_upload, './spec/testfiles/actual.pdf')
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_css(".alert-danger")
      expect(page).not_to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.file_too_big"))
    end
  end

  scenario "saving to db fails" do
    mock_writing_to_filesystem do
      allow_any_instance_of(AgreementLetter).to receive(:valid?).and_return(false)
      attach_file(:letter_upload, './spec/testfiles/actual.pdf')
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_css(".alert-danger")
      expect(page).not_to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.upload_failed"))
    end
  end

  scenario "saving file fails" do
    mock_writing_to_filesystem do
      allow(File).to receive(:write).and_raise(IOError)
      attach_file(:letter_upload, './spec/testfiles/actual.pdf')
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_css(".alert-danger")
      expect(page).not_to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.write_failed"))
    end
  end

  scenario "user uploads no file" do
    mock_writing_to_filesystem do
      click_button "upload_btn_#{@event.id}"
      expect(page).to have_css(".alert-danger")
      expect(page).not_to have_css(".alert-success")
      expect(page).to have_text(I18n.t("agreement_letters.not_a_file"))
    end
  end
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
    fill_in "profile_school", with: ""
    fill_in "profile_street_name", with:   "Rudolf-Breitscheid-Str. 52"
    fill_in "profile_zip_code", with:   "14482"
    fill_in "profile_city" , with:  "Potsdam"
    fill_in "profile_state" , with:  "Babelsberg"
    fill_in "profile_country" , with:  "Deutschland"

    find('input[name=commit]').click

    expect(page).to have_css(".has-error", count: 9)
  end

  scenario "user fills in a valid birth date" do
    @profile = FactoryGirl.create(:profile)
    login_as(@profile.user, :scope => :user)
    visit edit_profile_path(@profile)

    fill_in "profile_birth_date", with: Date.yesterday

    find('input[name=commit]').click

    expect(page).to have_text('Profile was successfully updated.')
  end

  scenario "user fills in an invalid birth date" do
    @profile = FactoryGirl.create(:profile)
    login_as(@profile.user, :scope => :user)
    visit edit_profile_path(@profile)

    fill_in "profile_birth_date", with: Date.tomorrow

    find('input[name=commit]').click

    expect(page).to have_css(".has-error", count: 3)
  end
end
