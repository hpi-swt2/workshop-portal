require 'rails_helper'

RSpec.describe "workshops/show", type: :view do
  before(:each) do
    @workshop = assign(:workshop, FactoryGirl.create(:workshop))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@workshop.name)
    expect(rendered).to have_text(@workshop.description)
    expect(rendered).to have_text(@workshop.max_participants)
  end
end
