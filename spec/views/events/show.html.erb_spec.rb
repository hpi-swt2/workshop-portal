require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event, :with_two_date_ranges))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user, role: :admin), event: @event)
    @application_letter.user.profile = FactoryGirl.build(:profile)
    @event.application_letters.push(@application_letter)
    @application_letters = @event.application_letters
    @material_files = []
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

  it "displays print applications button" do
    render
    expect(rendered).to have_link(t(:print_all, scope: 'events.applicants_overview'))
  end

  it "displays print badges button" do
    render
    expect(rendered).to have_link(t(:print_button_label, scope: 'events.badges'))
  end

  it "should not display accept-all-button for non-organizers" do
    @event.max_participants = Float::INFINITY
    [:coach, :student].each do | each |
      sign_in(FactoryGirl.create(:user, role: each))
      render
      expect(rendered).to_not have_link(I18n.t('events.applicants_overview.accept_all'))
    end
  end

  it "should display accept-all-button for organizers if there are enough free places" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    @event.max_participants = Float::INFINITY
    render
    expect(rendered).to have_link(I18n.t('events.applicants_overview.accept_all'))
  end

  it "should not display accept-all-button if there are not enough free places" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    @event.max_participants = 1
    2.times do
      @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: @event)
      @application_letter.user.profile = FactoryGirl.build(:profile)
      @event.application_letters.push(@application_letter)
    end
    render
    expect(rendered).to_not have_link(I18n.t('events.applicants_overview.accept_all'))
  end

  it "displays material area" do
    render
    expect(rendered).to have_text(t(:title, title: @event.name, scope: 'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_name, scope:'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_type, scope:'events.material_area'))
    expect(rendered).to have_button(t(:upload, scope: 'events.material_area'))
  end
end
