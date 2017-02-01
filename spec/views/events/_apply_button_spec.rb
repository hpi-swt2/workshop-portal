require 'rails_helper'

RSpec.describe "events/_apply_button", type: :view do
  before(:each) do
    @event = FactoryGirl.create(:event, :in_application_phase)
  end

  %i[pupil admin].each do |role|
    it "as #{role} you can see the apply button" do
      user = FactoryGirl.create(:user, role: role)
      sign_in user
      render partial: 'events/apply_button', locals: {event: @event}
      expect(rendered).to have_link(t('helpers.links.apply'), href: new_application_letter_path(event_id: @event.id))
    end
  end

  %i[coach organizer].each do |role|
    it "as #{role} you cannot see the apply button" do
      user = FactoryGirl.create(:user, role: role)
      sign_in user
      render partial: 'events/apply_button', locals: {event: @event}
      expect(rendered).to_not have_link(t('helpers.links.apply'), href: new_application_letter_path(event_id: @event.id))
    end
  end
end
