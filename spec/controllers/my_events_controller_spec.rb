require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do

	
	context "with a logged in user" do
	    before :each do
	      sign_in @application.user
	    end
		describe "GET #index" do
			it "renders the index page" do
	        	get :index
	        	expect(response).to render_template("index")
	      	end
	      	it "redirects to application letter edit if edit button is clicked" do
	      		get :index
	      		click "Bearbeiten"
	        	current_path.should == edit_application_letter_path
	      	end
		end
	end
end
