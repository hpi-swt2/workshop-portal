require 'rails_helper'

RSpec.describe "requests/new", type: :view do
  before(:each) do
    assign(:request, FactoryGirl.build(:request))
  end

  it "renders new request form" do
    render

    assert_select "form[action=?][method=?]", requests_path, "post" do
      assert_select "input#request_first_name[name=?]", "request[first_name]"
      assert_select "input#request_last_name[name=?]", "request[last_name]"
    end
  end
end
