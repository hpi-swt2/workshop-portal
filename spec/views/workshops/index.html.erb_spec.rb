require 'rails_helper'

RSpec.describe "workshops/index", type: :view do
  before(:each) do
    @ws = FactoryGirl.create(:workshop)
    assign(:workshops, [@ws, @ws])
  end

  it "renders a list of workshops" do
    render
    assert_select "td", :text => @ws.name, :count => 2
    assert_select "td", :text => @ws.description, :count => 2
  end
end
