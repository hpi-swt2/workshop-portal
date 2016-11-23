require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @ws = FactoryGirl.create(:event)
    assign(:events, [@ws, @ws])
  end

  it "renders a list of events" do
    render
    assert_select "td", :text => @ws.name, :count => 2
    assert_select "td", :text => @ws.description, :count => 2
  end
end
