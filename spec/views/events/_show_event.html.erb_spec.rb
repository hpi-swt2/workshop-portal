require 'rails_helper'

RSpec.describe "events/_show_event", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
  end

  %i[pupil admin].each do |role|
    it "as #{role} you can see the apply button" do
      user = FactoryGirl.create(:user, role: role)
      sign_in user
      render
      expect(rendered).to have_link(t('helpers.links.apply'), href: new_application_letter_path(event_id: @event.id))
    end
  end

  %i[coach organizer].each do |role|
    it "as #{role} you can not see the apply button" do
      user = FactoryGirl.create(:user, role: role)
      sign_in user
      render
      expect(rendered).to_not have_link(t('helpers.links.apply'), href: new_application_letter_path(event_id: @event.id))
    end
  end
end
