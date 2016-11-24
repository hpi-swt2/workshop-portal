require 'rails_helper'
require 'request_helper'

RSpec.describe "Applications", type: :request do
  describe "GET /applications" do
    it "works! (now write some real specs)" do
      login FactoryGirl.create(:user)
      get application_letters_path
      expect(response).to have_http_status(200)
    end
  end
end
