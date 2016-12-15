require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@event.name)
    expect(rendered).to have_text(@event.description)
    expect(rendered).to have_text(@event.max_participants)
  end
end
