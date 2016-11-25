require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user, role: :admin), event: @event)
    @application_letter.user.profile = FactoryGirl.build(:profile)
    @event.application_letters.push(@application_letter)
    sign_in(@application_letter.user)
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
    expect(rendered).to have_css("th", :text => t(:name, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:gender, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:age, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:participation_count, scope:'activerecord.attributes.user'))
    expect(rendered).to have_css("th", :text => t(:status, scope: 'events.applicants_overview'))
  end

  it "displays applicants information" do
    render
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.name)
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.gender)
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.age)
  end

  it "displays application details button" do
    render
    expect(rendered).to have_link(t(:details, scope: 'events.applicants_overview'))
  end
end
