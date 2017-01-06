require 'rails_helper'

RSpec.describe "requests/edit", type: :view do
  before(:each) do
    @request = assign(:request, FactoryGirl.create(:request, topic_of_workshop: 'Topics'))
  end

  it "renders the edit request form" do
    render

    assert_select "form[action=?][method=?]", request_path(@request), "post" do
      assert_select "input#request_first_name[name=?]", "request[first_name]"
      assert_select "input#request_last_name[name=?]", "request[last_name]"
    end
  end
end
