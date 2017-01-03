require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @event = FactoryGirl.create(:event)
    assign(:events, [@event, @event])
  end

  it "displays the name, the eventkind, the timespan and the status" do
    render
    assert_select "td", :text => @event.name
    assert_select "td", :text => I18n.t("events.kinds.#{@event.kind}")
    assert_select "td", :date => @event.start_date
    assert_select "td", :date => @event.end_date
    assert_select "td", :boolean => @event.draft
  end

  it "shouldn't have an id displayed" do
    render
    expect(rendered).to_not have_text("Id")
  end

  it "should not display new, edit, delete buttons for non-organizers" do
    sign_in(FactoryGirl.create(:user, role: :coach))
    render
    expect(rendered).to_not have_link(I18n.t('helpers.links.new'))
    expect(rendered).to_not have_link(I18n.t('helpers.links.edit'))
    expect(rendered).to_not have_link(I18n.t('helpers.links.destroy'))

  end

  it "should display new, edit, delete buttons for organizers" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(I18n.t('helpers.links.new'))
    expect(rendered).to have_link(I18n.t('helpers.links.edit'))
    expect(rendered).to have_link(I18n.t('helpers.links.destroy'))
  end
end
