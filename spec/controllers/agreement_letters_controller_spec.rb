require 'rails_helper'

RSpec.describe AgreementLettersController, type: :controller do

  describe "POST #create" do
    before :each do
      @user = FactoryGirl.create(:user, role: :pupil)
      @user.profile ||= FactoryGirl.create(:profile)
      sign_in @user
    end

    it "redirects to user profile" do
      file = fixture_file_upload(Rails.root.join('spec/testfiles/actual.pdf'), 'application/pdf')
      post :create, { letter_upload: file }
      expect(response).to have_http_status(:redirect)
    end

    it "shows error when POSTed with wrong parameters" do
      post :create
      expect(response).to have_http_status(422)
    end

    it "saves a file on the server" do
      file = fixture_file_upload(Rails.root.join('spec/testfiles/actual.pdf'), 'application/pdf')
      post :create, { letter_upload: file }
      @agreement_letter = assigns(:agreement_letter)
      filepath = Rails.root.join('storage/agreement_letters', @agreement_letter.filename)
      expect(File.exists?(filepath)).to be true
    end

    it "saves a file's path in the database" do
      file = fixture_file_upload(Rails.root.join('spec/testfiles/actual.pdf'), 'application/pdf')
      post :create, { letter_upload: file }
      @agreement_letter = assigns(:agreement_letter)
      AgreementLetter.where(
        user: @user,
        event: Event.find(1), #TODO
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
