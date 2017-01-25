require 'rails_helper'

RSpec.describe "events/badges", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
    @participants = assign(:participants, @event.participants)
  end

  it "renders the options" do
    render
    expect(rendered).to have_selector("input[type=file]", id:"logo_upload")
    expect(rendered).to have_select("name_format")
    expect(rendered).to have_selector("input[type=checkbox]", id:"show_school")
    expect(rendered).to have_selector("input[type=checkbox]", id:"show_color")
  end
end

