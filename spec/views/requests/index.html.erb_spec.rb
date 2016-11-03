require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    assign(:requests, [
      Request.create!(
        :topics => "Topics",
        :user => nil
      ),
      Request.create!(
        :topics => "Topics",
        :user => nil
      )
    ])
  end

  it "renders a list of requests" do
    render
    assert_select "tr>td", :text => "Topics".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
