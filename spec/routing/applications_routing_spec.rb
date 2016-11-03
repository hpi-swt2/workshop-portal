require "rails_helper"

RSpec.describe ApplicationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/applications").to route_to("applications#index")
    end

    it "routes to #new" do
      expect(:get => "/applications/new").to route_to("applications#new")
    end

    it "routes to #show" do
      expect(:get => "/applications/1").to route_to("applications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/applications/1/edit").to route_to("applications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/applications").to route_to("applications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/applications/1").to route_to("applications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/applications/1").to route_to("applications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/applications/1").to route_to("applications#destroy", :id => "1")
    end

  end
end
