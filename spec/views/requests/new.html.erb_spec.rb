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
      assert_select "input#request_phone_number[name=?]", "request[phone_number]"
      assert_select "input#request_street[name=?]", "request[street]"
      assert_select "input#request_zip_code_city[name=?]", "request[zip_code_city]"
      assert_select "input#request_email[name=?]", "request[email]"
      assert_select "input#request_topic_of_workshop[name=?]", "request[topic_of_workshop]"
      assert_select "input#request_time_period[name=?]", "request[time_period]"
      assert_select "input#request_number_of_participants[name=?]", "request[number_of_participants]"
      assert_select "input#request_knowledge_level[name=?]", "request[knowledge_level]"
      assert_select "textarea#request_annotations[name=?]", "request[annotations]"
    end
  end
end
