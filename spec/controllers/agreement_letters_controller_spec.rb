require 'rails_helper'

RSpec.describe AgreementLettersController, type: :controller do

  describe "POST #upload" do
    it "redirects" do
      post :upload
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #download" do
    it "redirects" do
      get :download
      expect(response).to have_http_status(:redirect)
    end
  end

end
