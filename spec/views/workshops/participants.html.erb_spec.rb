require 'rails_helper'

RSpec.describe "workshops/participants", type: :view do
  before(:each) do
    @workshop = assign(:workshop, FactoryGirl.create(:workshop))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text("Einverständniserklärung")
    expect(rendered).to have_text(@workshop.participants[0].name)
  end
end
