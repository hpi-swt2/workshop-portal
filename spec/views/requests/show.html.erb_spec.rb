require 'rails_helper'

RSpec.describe "requests/show", type: :view do
  before(:each) do
    @aRequest = assign(:request, FactoryGirl.create(:request, topic_of_workshop: 'Topics', status: :open))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@aRequest.topic_of_workshop)
    expect(rendered).to have_text(@aRequest.first_name)
    expect(rendered).to have_text(@aRequest.last_name)
    expect(rendered).to have_text(@aRequest.number_of_participants)
    expect(rendered).to have_text(@aRequest.status)
  end

  it "should not display edit, delete buttons for non-organizers" do
    sign_in(FactoryGirl.create(:user, role: :coach))
    render
    expect(rendered).to_not have_link(I18n.t('helpers.links.edit'))
    expect(rendered).to_not have_link(I18n.t('helpers.links.destroy'))
  end

  it "should display edit, delete, accept buttons for organizers" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(I18n.t('helpers.links.edit'))
    expect(rendered).to have_link(I18n.t('helpers.links.destroy'))
    expect(rendered).to have_link(I18n.t('requests.form.accept'))
  end

  it "doesn't show the accept button for accepted events" do
    @aRequest = assign(:request, FactoryGirl.create(:request, topic_of_workshop: 'Topics', status: :accepted))
    expect(rendered).not_to have_link(I18n.t('helpers.links.accept'))
  end
end
