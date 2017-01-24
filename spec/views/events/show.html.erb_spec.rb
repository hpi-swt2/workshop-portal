require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event, :with_two_date_ranges))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user, role: :admin), event: @event)
    @application_letter.user.profile = FactoryGirl.build(:profile)
    @event.application_letters.push(@application_letter)
    @application_letters = @event.application_letters
    @material_files = ["spec/testfiles/actual.pdf"]
    sign_in(@application_letter.user)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@event.name)
    expect(rendered).to have_text(@event.description)
    expect(rendered).to have_text(@event.max_participants)
    expect(rendered).to have_text(@event.organizer)
    expect(rendered).to have_text(@event.knowledge_level)
  end

  it "displays counter" do
    free_places = assign(:free_places, @event.compute_free_places)
    occupied_places = assign(:occupied_places, @event.compute_occupied_places)
    render
    expect(rendered).to have_text(I18n.t 'free_places', count: free_places, scope: [:events, :applicants_overview])
    expect(rendered).to have_text(I18n.t 'occupied_places', count: occupied_places, scope: [:events, :applicants_overview])
  end

  it "renders applicants table" do
    render
    expect(rendered).to have_table("applicants")
  end

  it "renders applicants table header fields" do
    render
    expect(rendered).to have_css("th", :text => t(:name, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:gender, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:age, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:participations, scope: 'events.applicants_overview'))
    expect(rendered).to have_css("th", :text => t(:status, scope: 'events.applicants_overview'))
  end

  it "displays applicants information" do
    render
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.name)
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.gender)
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.age_at_time(@event.start_date))
  end

  it "displays application details button" do
    render
    expect(rendered).to have_link(t(:details, scope: 'events.applicants_overview'))
  end

  it "should not display accept-all-button for non-organizers" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase))
    @event.max_participants = Float::INFINITY
    [:coach, :pupil].each do | each |
      sign_in(FactoryGirl.create(:user, role: each))
      render
      expect(rendered).to_not have_link(I18n.t('events.applicants_overview.accept_all'))
    end
  end

  it "should display accept-all-button for organizers if there are enough free places" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    @event.max_participants = Float::INFINITY
    render
    expect(rendered).to have_link(I18n.t('events.applicants_overview.accept_all'))
  end

  it "should not display accept-all-button if there are not enough free places" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    @event.max_participants = 1
    render
    expect(rendered).to_not have_link(I18n.t('events.applicants_overview.accept_all'))
  end

  it "displays material area" do
    render
    expect(rendered).to have_text(t(:title, title: @event.name, scope: 'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_name, scope:'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_type, scope:'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_action, scope:'events.material_area'))
    expect(rendered).to have_button(t(:upload, scope: 'events.material_area'))
    expect(rendered).to have_button(t(:download, scope: 'events.material_area'))
  end

  it "displays correct buttons in draft phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_draft_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:show_participants, scope: 'events.participants'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in application phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_application_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:show_participants, scope: 'events.participants'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "does not display the disabled send email buttons in application phase (even when there are unclassified applications)" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_application_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in selection phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:show_participants, scope: 'events.participants'))
  end

  it "displays the disabled send email buttons in selection phase (when there are unclassified applications)" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays the disabled send email buttons in selection phase (when there are too many accepted applications)" do
    @event = assign(:event, FactoryGirl.create(:event_with_accepted_applications, :in_selection_phase, max_participants: 1))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in execution phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_execution_phase))
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:show_participants, scope: 'events.participants'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end
end
