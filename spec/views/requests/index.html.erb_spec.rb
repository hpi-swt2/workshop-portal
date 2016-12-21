require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    @topics = 'Topics'
    assign(:requests, [
      FactoryGirl.create(:request, topics: @topics),
      FactoryGirl.create(:request, topics: @topics)
    ])
  end

  it "renders a list of requests" do
    render
    assert_select "tr>td", :text => @topics, :count => 2
  end

  it "shouldn't have an id displayed" do
    render
    expect(rendered).to_not have_text("Id")
  end
end
