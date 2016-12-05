require 'rails_helper'

RSpec.describe "myevents/index", type: :view do
  
context "checks states of applications" do
	it "checks if page displays accepted application" do
		@application_letters = [FactoryGirl.create(:application_letter_accepted)]
		render
		expect(rendered).to have_content("Angenommen")
	end
	it "checks if page displays rejected application" do
		@application_letters = [FactoryGirl.create(:application_letter_rejected)]
		render
		expect(rendered).to have_content("Abgelehnt")
	end
	it "checks if page displays pending application after deadline" do
		@application_letters = [FactoryGirl.create(:application_letter_pending_after_deadline)]
		render
		expect(rendered).to have_content("In Bearbeitung")
	end
	it "checks if page displays pending application before deadline" do
		@application_letters = [FactoryGirl.create(:application_letter)]
		render
		expect(rendered).to have_content("Beworben")
	end
end
  it "checks if page displays edit button for pending event" do
	@application_letters = [FactoryGirl.create(:application_letter)]
	render
	expect(rendered).to have_button("Bearbeiten")
  end
  it "doesn't display edit button after deadline" do
	@application_letters = [FactoryGirl.create(:application_letter)]
	render
	expect(rendered).to_not have_button("Bearbeiten")
  end
end
