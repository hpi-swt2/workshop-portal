require 'rails_helper'

RSpec.describe "workshops/show", type: :view do
  before(:each) do
    @event = assign(:workshop, FactoryGirl.create(:event))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: event)
    @application_letter.user.profile = FactoryGirl.build(:profile)
    @event.application_letters.push(@application_letter)
  end



  it "renders attributes" do
    render
    expect(rendered).to have_text(@event.name)
    expect(rendered).to have_text(@event.description)
    expect(rendered).to have_text(@event.max_participants)
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
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.name)
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.gender)
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.age)
  end

  it "displays application details button" do
    render
    expect(rendered).to have_link("Details")
  end

end
