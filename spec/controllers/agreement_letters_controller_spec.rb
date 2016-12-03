require 'rails_helper'

RSpec.describe AgreementLettersController, type: :controller do

  describe "POST #create" do
    before :each do
      @user = FactoryGirl.create(:user, role: :pupil)
      @user.profile ||= FactoryGirl.create(:profile)
      @event = FactoryGirl.create(:event)
      filepath = Rails.root.join('spec/testfiles/actual.pdf')
      @file = fixture_file_upload(filepath, 'application/pdf')
      sign_in @user
    end

    it "redirects to user profile" do
      post :create, { letter_upload: @file, event_id: @event.id }
      expect(response).to redirect_to(profile_path(@user.profile))
    end

    it "shows error when POSTed without a file" do
      post :create, { event_id: @event.id }
      expect(response).to have_http_status(422)
    end

    it "shows error when POSTed with an inexistent event" do
      @event.delete
      post :create, { letter_upload: @file, event_id: @event.id }
      expect(response).to have_http_status(422)
    end

    it "saves a file on the server" do
      post :create, { letter_upload: @file, event_id: @event.id }
      @agreement_letter = assigns(:agreement_letter)
      filepath = Rails.root.join('storage/agreement_letters', @agreement_letter.filename)
      expect(File.exists?(filepath)).to be true
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
      @user = FactoryGirl.create(:user, role: :pupil)
      @user.profile ||= FactoryGirl.create(:profile)
      @event = FactoryGirl.create(:event)
      filepath = Rails.root.join('spec/testfiles/actual.pdf')
      @file = fixture_file_upload(filepath, 'application/pdf')
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
