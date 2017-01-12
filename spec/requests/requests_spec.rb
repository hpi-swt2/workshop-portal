require 'rails_helper'

RSpec.describe "Requests", type: :request do
  describe "GET /requests" do
    it "redirects to another page (where e.g. the permissions error is displayed) per default" do
      get requests_path
      expect(response).to have_http_status(302)
    end

    it "shows the page for users with the right permissions" do
      profile = FactoryGirl.create(:profile)
      coach = FactoryGirl.create(:user, role: :coach, profile: profile)
      login_as(coach, scope: :user)
      get requests_path
      expect(response).to have_http_status(200)
    end
  end
end
