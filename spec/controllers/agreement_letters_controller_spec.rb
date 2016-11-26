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
      expect(response).to have_http_status(:redirect)
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

  describe "GET #show" do
    it "redirects to user profile" do
      @user = FactoryGirl.create(:user, role: :pupil)
      @user.profile ||= FactoryGirl.create(:profile)
      sign_in @user
      get :show
      expect(response).to have_http_status(:redirect)
    end
  end

end
