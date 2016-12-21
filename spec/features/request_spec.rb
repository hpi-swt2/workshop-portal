require "rails_helper"

describe "Request", type: :feature do
  describe "index page" do
    it "should link to the show page when a request topic is clicked" do
      request = FactoryGirl.create :request
      visit requests_path
      click_link request.topics
      expect(page).to have_current_path(request_path(request))
    end
  end
end
