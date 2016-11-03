require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "GET /applications" do
    it "works! (now write some real specs)" do
      get applications_path
      expect(response).to have_http_status(200)
    end
  end
end
