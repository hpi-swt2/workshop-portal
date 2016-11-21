require 'rails_helper'

RSpec.describe "workshops/show", type: :view do
  before(:each) do
    @workshop = assign(:workshop, FactoryGirl.create(:workshop))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), workshop: @workshop)
    @workshop.application_letters.push(@application_letter)
  end



  it "renders attributes" do
    render
    expect(rendered).to have_text(@workshop.name)
    expect(rendered).to have_text(@workshop.description)
    expect(rendered).to have_text(@workshop.max_participants)
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
    expect(rendered).to have_css("td", :text => @workshop.application_letters.first.user.name)
  end

  it "displays application details button" do
    render
    expect(rendered).to have_link("Details")
  end

end
