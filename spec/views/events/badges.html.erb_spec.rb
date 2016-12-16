require 'rails_helper'

RSpec.describe "events/badges", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
    @participants = assign(:participants, @event.participants)
  end

  it "renders the options" do
    render
    expect(rendered).to have_selector("input[type=file]", "logo_upload")
    expect(rendered).to have_select("name_select")
    expect(rendered).to have_selector("input[type=checkbox]", "show_organization")
    expect(rendered).to have_selector("input[type=checkbox]", "show_color")
  end
end

