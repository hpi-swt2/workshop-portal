require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do
      assert_select "input#event_name[name=?]", "event[name]"
      assert_select "textarea#description[name=?]", "event[description]"
      assert_select "input#event_max_participants[name=?]", "event[max_participants]"
      assert_select "input#event_organizer[name=?]", "event[organizer]"
      assert_select "input#event_knowledge_level[name=?]", "event[knowledge_level]"
    end
  end

  it "shows that organizer and knowledge_level are optional" do
    render
    expect(rendered).to have_field("event_organizer", :placeholder => "optional")
    expect(rendered).to have_field("event_knowledge_level", :placeholder => "optional")
  end

  it "should have a delete button" do
    @event = assign(:event, FactoryGirl.create(:event))
    render
    assert_select 'a[data-method="delete"]'
  end

  it "should have an update button for events that haven't been published" do
    @event = assign(:event, FactoryGirl.create(:event, published: false))
    render
    assert_select "input[name=update]"
  end

  it "shouldn't have a create button, but should have a update button for events that have already been published" do
    @event = assign(:event, FactoryGirl.create(:event, published: true))
    render
    assert_select "input[name=create]", false
    assert_select "input[name=update]"
  end
end
