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

  it "displays correct groups" do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user)
    @event = FactoryGirl.create(:event)
    @application_letter = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    @participant_group = FactoryGirl.create(:participant_group, user: @user, event: @event)
    assign(:event, @event)
    assign(:participants, @event.participants)
    render
    expect(rendered).to have_select('participant_group_group', selected: I18n.t("participant_groups.options.#{ParticipantGroup::GROUPS[@participant_group.group]}"))
  end

  it "displays select element with all options" do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user)
    @event = FactoryGirl.create(:event)
    @application_letter = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    @participant_group = FactoryGirl.create(:participant_group, user: @user, event: @event)
    assign(:event, @event)
    assign(:participants, @event.participants)
    render
    expect(rendered).to have_select('participant_group_group', options: ParticipantGroup::GROUPS.map { |m| I18n.t("participant_groups.options.#{m.last}") })
  end

  it "contains a modal to print participant lists" do
    render
    expect(rendered).to have_css('div#print_participant_modal')
    expect(rendered).to have_css('button#open_print_modal')
    expect(rendered).to have_css('input#print_participant_list')
  end
end
