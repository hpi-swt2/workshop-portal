require 'rails_helper'

RSpec.describe AgreementLettersController, type: :controller do

  describe "POST #create" do
    before :each do
      @user = FactoryGirl.create(:user_with_profile, role: :pupil)
      @event = FactoryGirl.create(:event)
      @application = FactoryGirl.create(:application_letter, user: @user, event: @event)
      filepath = Rails.root.join('spec/testfiles/actual.pdf')
      @file = fixture_file_upload(filepath, 'application/pdf')
      sign_in @user
    end

    it "redirects to user profile" do
      post :create, { letter_upload: @file, event_id: @event.id }
      expect(response).to redirect_to(check_application_letter_path(ApplicationLetter.where(user_id: @user.id, event_id: @event.id).first))
    end

    it "saves a file's path in the database" do
      post :create, { letter_upload: @file, event_id: @event.id }
      @agreement_letter = assigns(:agreement_letter)
      AgreementLetter.where(
          user: @user,
          event: @event,
          path: Rails.root.join('storage/agreement_letters', @agreement_letter.filename).to_s)
          .take!
    end
  end

  describe "POST #create when file was already created" do
    before :each do
      @user = FactoryGirl.create(:user_with_profile, role: :pupil)
      @event = FactoryGirl.create(:event)
      filepath = Rails.root.join('spec/testfiles/actual.pdf')
      @file = fixture_file_upload(filepath, 'application/pdf')
      @application = FactoryGirl.create(:application_letter, user: @user, event: @event)
      another_filepath = Rails.root.join('spec/testfiles/another_actual.pdf')
      @another_file = fixture_file_upload(another_filepath, 'application/pdf')
      sign_in @user
    end

    it "updates existing db entry when replacing a file" do
      post :create, { letter_upload: @file, event_id: @event.id }
      expect(AgreementLetter.where(user: @user, event: @event).size).to eq 1
      post :create, { letter_upload: @another_file, event_id: @event.id }
      expect(AgreementLetter.where(user: @user, event: @event).size).to eq 1
    end

    it "overwrites file when user uploads to same event twice" do
      post :create, { letter_upload: @file, event_id: @event.id }
      @agreement_letter = assigns(:agreement_letter)
      expect(File.size(@agreement_letter.path)).to eq @file.size
      post :create, { letter_upload: @another_file, event_id: @event.id }
      expect(File.exists?(@agreement_letter.path)).to be true
      expect(File.size(@agreement_letter.path)).to eq @another_file.size
    end
  end
end
