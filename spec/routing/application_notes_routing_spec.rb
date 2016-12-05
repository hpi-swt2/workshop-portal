require "rails_helper"

RSpec.describe ApplicationNotesController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "/applications/1/application_notes").to route_to("application_notes#create", application_letter_id: "1")
    end
  end
end
