require 'rails_helper'

RSpec.describe "application_letters/index", type: :view do

  context "checks states of applications" do
    it "checks if page displays accepted application" do
      @application_letters = [FactoryGirl.create(:application_letter_accepted)]
      render
      expect(rendered).to have_content("Angenommen")
    end
    it "checks if page displays rejected application" do
      @application_letters = [FactoryGirl.create(:application_letter_rejected)]
      render
      expect(rendered).to have_content("Abgelehnt")
    end
    it "checks if page displays pending application after deadline" do
      @application_letters = [FactoryGirl.create(:application_letter)]
      @application_letters[0].event.application_deadline = Date.yesterday
      render
      expect(rendered).to have_content("In Bearbeitung")
    end
    it "checks if page displays pending application before deadline" do
      @application_letters = [FactoryGirl.create(:application_letter)]
      render
      expect(rendered).to have_content("Beworben")
    end
  end

  it "should display the name of the event" do
    @application_letters = [FactoryGirl.create(:application_letter)]
    render
    expect(rendered).to have_content(@application_letters[0].event.name)
  end

  it "should display the edit button for a pending event" do
    @application_letters = [FactoryGirl.create(:application_letter)]
    render
    expect(rendered).to have_css("a.btn", :text => "Bearbeiten")
  end
  it "should not display edit button after deadline" do
    @application_letters = [FactoryGirl.build(:application_letter_deadline_over)]
    render
    expect(rendered).to_not have_css("a.btn", :text => "Bearbeiten")
  end
  it "should have link with the event name" do
    @application_letters = [FactoryGirl.create(:application_letter)]
    render
    expect(rendered).to have_link(@application_letters[0].event.name, href: event_path(@application_letters[0].event.id))
  end
end