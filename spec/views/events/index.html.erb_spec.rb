require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @event = FactoryGirl.create(:event)
    assign(:events, [@event, @event])
  end

  it "displayes the name" do
    render
    assert_select "td", :text => @event.name
  end

  it "displayes the eventkind" do
    render
    assert_select "td", :text => @event.kind
  end

  it "displays the timespan" do
    render
    assert_select "td", :date => @event.start_date
    assert_select "td", :date => @event.end_date
  end

  it "displayes the status" do
    render
    assert_select "td", :boolean => @event.draft
  end
end
