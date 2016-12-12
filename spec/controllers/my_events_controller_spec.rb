require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do

  let(:application) { FactoryGirl.build(:application_letter).attributes.merge(status: :pending) }

  context "with a logged in user" do
    before :each do
      @application = ApplicationLetter.create! application
      sign_in @application.user
    end
    describe "GET #index" do
      it "renders the index page" do
        get :index
        expect(response).to render_template("index")
      end
    end
  end
end
