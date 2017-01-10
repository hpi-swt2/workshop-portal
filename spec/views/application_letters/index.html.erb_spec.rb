require 'rails_helper'

RSpec.describe "application_letters/index", type: :view do

  context "checks states of applications" do
    it "checks if page displays accepted application" do
      @application_letters = [FactoryGirl.create(:application_letter_accepted)]
      render
      expect(rendered).to have_content(I18n.t("application_status.accepted"))
    end
    it "checks if page displays rejected application" do
      @application_letters = [FactoryGirl.create(:application_letter_rejected)]
      render
      expect(rendered).to have_content(I18n.t("application_status.rejected"))
    end
    it "checks if page displays pending application after deadline" do
      @application_letters = [FactoryGirl.create(:application_letter)]
      @application_letters[0].event.application_deadline = Date.yesterday
      render
      expect(rendered).to have_content(I18n.t("application_status.pending_after_deadline"))
    end
    it "checks if page displays pending application before deadline" do
      @application_letters = [FactoryGirl.create(:application_letter)]
      render
      expect(rendered).to have_content(I18n.t("application_status.pending_before_deadline"))
    end
    it "checks if page displays alternative status application letter" do
      @application_letters = [FactoryGirl.create(:application_letter_alternative)]
      render
      expect(rendered).to have_content(I18n.t("application_status.alternative"))
    end
  end

  it "should display the name of the event" do
    @application_letters = [FactoryGirl.create(:application_letter)]
    render
    expect(rendered).to have_content(@application_letters[0].event.name)
  end

  it "should display the details button" do
    @application_letters = [FactoryGirl.create(:application_letter)]
    render
    expect(rendered).to have_css("a.btn", :text => I18n.t('application_letters.index.details'))
  end

  it "should have link with the event name" do
    @application_letters = [FactoryGirl.create(:application_letter)]
    render
    expect(rendered).to have_link(@application_letters[0].event.name, href: event_path(@application_letters[0].event.id))
  end
end
