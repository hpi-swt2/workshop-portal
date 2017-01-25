require "rails_helper"

RSpec.describe EmailsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/events/1/emails").to route_to("emails#show", event_id: "1")
    end

    it "routes to #submit" do
      expect(post: "/events/1/emails").to route_to("emails#submit", event_id: "1")
    end
  end
end