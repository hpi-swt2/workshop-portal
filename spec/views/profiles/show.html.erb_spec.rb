require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@profile.cv)
  end

  it "renders the events table" do
    render
    expect(rendered).to have_table("events_table")
  end
end
