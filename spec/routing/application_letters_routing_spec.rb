require "rails_helper"

RSpec.describe ApplicationLettersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/applications").to route_to("application_letters#index")
    end

    it "routes to #new" do
      expect(:get => "/applications/new").to route_to("application_letters#new")
    end

    it "routes to #show" do
      expect(:get => "/applications/1").to route_to("application_letters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/applications/1/edit").to route_to("application_letters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/applications").to route_to("application_letters#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/applications/1").to route_to("application_letters#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/applications/1").to route_to("application_letters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/applications/1").to route_to("application_letters#destroy", :id => "1")
    end

  end
end
