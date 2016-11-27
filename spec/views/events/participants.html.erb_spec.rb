require 'rails_helper'

RSpec.describe "events/participants", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event_with_accepted_applications))
	@participants = assign(:participants, @event.participants)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text("Einverständniserklärung")
    expect(rendered).to have_text(@event.participants[0].name)
  end
  
  it "detects missing agreement letters" do
	@user = FactoryGirl.create(:user)
	@profile = FactoryGirl.create(:profile, user: @user, birth_date: 15.years.ago)
	@event = FactoryGirl.create(:event)
	@application = FactoryGirl.create(:accepted_application_letter, user: @user, event: @event)
	assign(:event, @event)
	assign(:participants, @event.participants)
	render
	expect(rendered).to have_text("nicht vorhanden")
  end
  
  it "detects available agreement letters" do
	@user = FactoryGirl.create(:user)
	@profile = FactoryGirl.create(:profile, user: @user, birth_date: 15.years.ago)
	@event = FactoryGirl.create(:event)
	@application = FactoryGirl.create(:accepted_application_letter, user: @user, event: @event)
	@agreement = FactoryGirl.create(:agreement_letter, user: @user, event: @event)
	assign(:event, @event)
	assign(:participants, @event.participants)
	render
	expect(rendered).to have_text("vorhanden")
	expect(rendered).not_to have_text("nicht vorhanden")
  end
  
  it "detects when agreement letters are unnecessary" do
	@user = FactoryGirl.create(:user)
	@profile = FactoryGirl.create(:profile, user: @user, birth_date: 19.years.ago)
	@event = FactoryGirl.create(:event)
	@application = FactoryGirl.create(:accepted_application_letter, user: @user, event: @event)
	@agreement = FactoryGirl.create(:agreement_letter, user: @user, event: @event)
	assign(:event, @event)
	assign(:participants, @event.participants)
	render
	expect(rendered).to have_text("unnötig")
  end
  
end
