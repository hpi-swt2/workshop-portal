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

    it "show error when POSTed with wrong parameters" do
      post :create
      expect(response).to have_http_status(422)
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
