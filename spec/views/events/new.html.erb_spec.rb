require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, FactoryGirl.build(:event))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do
      assert_select "input#event_name[name=?]", "event[name]"
      assert_select "input#event_description[name=?]", "event[description]"
      assert_select "input#event_max_participants[name=?]", "event[max_participants]"
      assert_select "input#event_organizer[name=?]", "event[organizer]"
      assert_select "input#event_knowledge_level[name=?]", "event[knowledge_level]"
    end
  end
end
