require 'rails_helper'

RSpec.describe "workshops/participants", type: :view do
  before(:each) do
    @workshop = assign(:workshop, FactoryGirl.create(:workshop_with_accepted_applications))
	@participants = assign(:participants, @workshop.participants)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text("Einverständniserklärung")
    expect(rendered).to have_text(@workshop.participants[0].name)
  end
end
