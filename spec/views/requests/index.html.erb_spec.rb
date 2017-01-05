require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    @topics = 'Topics'
    assign(:requests, [
      FactoryGirl.create(:request, topics: @topics),
      FactoryGirl.create(:request, topics: @topics)
    ])
  end

  it "renders a list of requests" do
    render
    assert_select "tr>td", :text => @topics, :count => 2
  end

  it "should not display the new button for non-pupils" do
    render
    expect(rendered).to_not have_link(I18n.t('helpers.links.new'))
  end

  it "should display new button but not display edit, delete buttons for non-organizers" do
    sign_in(FactoryGirl.create(:user, role: :coach))
    render
    expect(rendered).to have_link(I18n.t('helpers.links.new'))

    expect(rendered).to_not have_link(I18n.t('helpers.links.edit'))
    expect(rendered).to_not have_link(I18n.t('helpers.links.destroy'))
  end

  it "should display edit, delete buttons for organizers" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render

    expect(rendered).to have_link(I18n.t('helpers.links.edit'))
    expect(rendered).to have_link(I18n.t('helpers.links.destroy'))
  end
end
