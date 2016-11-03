require "rails_helper"

RSpec.describe WorkshopsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/workshops").to route_to("workshops#index")
    end

    it "routes to #new" do
      expect(:get => "/workshops/new").to route_to("workshops#new")
    end

    it "routes to #show" do
      expect(:get => "/workshops/1").to route_to("workshops#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/workshops/1/edit").to route_to("workshops#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/workshops").to route_to("workshops#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/workshops/1").to route_to("workshops#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/workshops/1").to route_to("workshops#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/workshops/1").to route_to("workshops#destroy", :id => "1")
    end

  end
end
