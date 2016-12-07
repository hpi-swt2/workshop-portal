require 'rails_helper'

RSpec.describe "events/send_email", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event_with_accepted_applications))
    @adresses = assign(:adresses, @event.email_adresses_of_accepted_applicants)
    sign_in(FactoryGirl.create(:user, role: :admin))
  end
end
