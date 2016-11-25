require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: @event)
    @event.application_letters.push(@application_letter)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@event.name)
    expect(rendered).to have_text(@event.description)
    expect(rendered).to have_text(@event.max_participants)
  end

  it "displays counter" do
    free_places = assign(:free_places, @event.compute_free_places)
    occupied_places = assign(:occupied_places, @event.compute_occupied_places)
    render
    expect(rendered).to have_text(free_places.to_s + " Plätze frei")
    expect(rendered).to have_text(occupied_places.to_s + " Plätze belegt")
  end

  it "renders applicants table" do
    render
    expect(rendered).to have_table("applicants")
  end

  it "renders applicants table header fields" do
    render
    expect(rendered).to have_css("th", :text => "Name")
    expect(rendered).to have_css("th", :text => "Geschlecht")
    expect(rendered).to have_css("th", :text => "Alter")
    expect(rendered).to have_css("th", :text => "Camp-Teilnahmen")
    expect(rendered).to have_css("th", :text => "Status")
  end

  it "displays applicants information" do
    render
    expect(rendered).to have_css("td", :text => @event.application_letters.first.user.name)
  end

  it "displays application details button" do
    render
    expect(rendered).to have_link("Details")
  end
end
