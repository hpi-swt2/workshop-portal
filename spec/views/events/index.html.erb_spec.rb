require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @event = FactoryGirl.create(:event)
    assign(:events, [@event, @event])
  end

  it "displays the name and the start date" do
    render
    assert_select "h3", :text => @event.name
    assert_select ".event-day", :date => I18n.l(@event.start_date, format: '%d')
    assert_select ".event-month", :date => I18n.l(@event.start_date, format: '%b')
  end

  it "shouldn't have an id displayed" do
    render
    expect(rendered).to_not have_text("Id")
  end

  it "should not display new, edit, delete buttons for non-organizers" do
    sign_in(FactoryGirl.create(:user, role: :coach))
    render
    expect(rendered).to_not have_link(I18n.t('helpers.links.new'))
    expect(rendered).to_not have_link(href: edit_event_path(@event))
    expect(rendered).to_not have_link(href: event_path(@event), class: 'btn-danger')
  end

  it "should display new, edit, delete buttons for organizers" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(I18n.t('helpers.links.new'))
    expect(rendered).to have_link(href: edit_event_path(@event))
    expect(rendered).to have_link(href: event_path(@event), class: 'btn-danger')
  end

  it "should not display apply button if application deadline is over" do
    @event.application_deadline = Date.yesterday
    assign(:events, [@event])
    [:pupil, :coach, :organizer].each do |role|
      sign_in FactoryGirl.create(:user, role: role)
      render
      expect(rendered).to_not have_link(I18n.t("helpers.links.apply"))
    end
  end

  it "should display button to view the application if application deadline is over for an event where the pupil has applied" do
    pupil = FactoryGirl.create(:user, role: :pupil)
    application_letter = FactoryGirl.create(:application_letter, user: pupil, event: @event)
    @event.application_deadline = Date.yesterday
    assign(:events, [@event])
    sign_in pupil
    render
    expect(rendered).to have_link(I18n.t("helpers.links.show_application"), href: check_application_letter_path(application_letter))
  end

end
