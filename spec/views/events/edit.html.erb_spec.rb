require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do
      assert_select "input#event_name[name=?]", "event[name]"
      assert_select "input#event_description[name=?]", "event[description]"
      assert_select "input#event_max_participants[name=?]", "event[max_participants]"
      assert_select "input#event_active[name=?]", "event[active]"
    end
  end
end
