require 'rails_helper'

RSpec.describe AgreementLettersController, type: :controller do

  describe "POST #upload" do
    it "redirects to user profile" do
      @user = FactoryGirl.create(:user, role: :pupil)
      @user.profile ||= FactoryGirl.create(:profile)
      sign_in @user
      post :upload
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #download" do
    it "redirects to user profile" do
      @user = FactoryGirl.create(:user, role: :pupil)
      @user.profile ||= FactoryGirl.create(:profile)
      sign_in @user
      get :download
      expect(response).to have_http_status(:redirect)
    end
  end

end
