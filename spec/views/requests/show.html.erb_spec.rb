require 'rails_helper'

RSpec.describe "requests/show", type: :view do
  before(:each) do
    @aRequest = assign(:request, FactoryGirl.create(:request, topics: 'Topics'))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@aRequest.topics)
  end

  it "should not display edit, delete buttons for non-organizers" do
    sign_in(FactoryGirl.create(:user, role: :coach))
    render
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
