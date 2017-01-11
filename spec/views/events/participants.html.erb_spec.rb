require 'rails_helper'

RSpec.describe "events/participants", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event_with_accepted_applications))
    @participants = assign(:participants, @event.participants)
    sign_in(FactoryGirl.create(:user, role: :admin))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(t(:participants, scope:'events.participants'))
    expect(rendered).to have_text(@event.participants[0].name)
  end

  it "detects missing agreement letters" do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user, birth_date: 15.years.ago)
    @event = FactoryGirl.create(:event)
    @application = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    assign(:event, @event)
    assign(:participants, @event.participants)
    render
    expect(rendered).to have_text(t(:unavailable, scope:'events.participants'))
  end

  it "detects available agreement letters" do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user, birth_date: 15.years.ago)
    @event = FactoryGirl.create(:event)
    @application = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    @agreement = FactoryGirl.create(:agreement_letter, user: @user, event: @event)
    assign(:event, @event)
    assign(:participants, @event.participants)
    render
    expect(rendered).to have_text(t(:available, scope:'events.participants'))
    expect(rendered).not_to have_text(t(:unavailable, scope:'events.participants'))
  end

  it "detects when agreement letters are unnecessary" do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user, birth_date: 19.years.ago)
    @event = FactoryGirl.create(:event)
    @application = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    @agreement = FactoryGirl.create(:agreement_letter, user: @user, event: @event)
    assign(:event, @event)
    assign(:participants, @event.participants)
    render
    expect(rendered).to have_text(t(:unnecessary, scope:'events.participants'))
  end

  it "displays groups" do
    pending("todo")
    fail
  end

  it "displays color picker with all options" do
    pending("todo")
    fail
  end

  it "displays success notice after new selection has been saved" do
    pending("todo")
    fail
  end

  it "displays alert notice after new selection failed to save" do
    pending("todo")
    fail
  end

end
