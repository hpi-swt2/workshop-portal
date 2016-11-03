require 'rails_helper'

RSpec.describe "requests/new", type: :view do
  before(:each) do
    assign(:request, Request.new(
      :topics => "MyString",
      :user => nil
    ))
  end

  it "renders new request form" do
    render

    assert_select "form[action=?][method=?]", requests_path, "post" do

      assert_select "input#request_topics[name=?]", "request[topics]"

      assert_select "input#request_user_id[name=?]", "request[user_id]"
    end
  end
end
