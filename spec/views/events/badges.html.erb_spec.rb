require 'rails_helper'

RSpec.describe "events/badges", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
    @participants = assign(:participants, @event.participants)
  end

  it "renders the print badges event page" do
    render
    assert_select "h1", :text => (I18n.t 'events.badges.title')  + "'" + @event.name + "'"
  end

  it "renders the generate pdf button" do
    render
    assert_select "a", :text => (I18n.t 'events.badges.print')
  end

  it "renders the list of the participants" do
    render
    assert_select "h3", :text => (I18n.t 'events.badges.participants')
  end
end
