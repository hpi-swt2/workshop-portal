require 'rails_helper'
require 'cancan/matchers'

RSpec.describe "events/_event", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
  end

  %i[coach organizer].each do |role|
    it "as #{role} you can not see the apply button" do
      render partial: 'events/event.html.erb', locals: {event: @event}
      expect(rendered).to_not have_link(t('helpers.links.apply'), href: new_application_letter_path(event_id: @event.id))
    end
  end
end
