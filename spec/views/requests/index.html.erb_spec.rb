require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    @topic_of_workshop = 'Topics'
    @requests = [
      FactoryGirl.create(:request, topic_of_workshop: @topic_of_workshop, first_name: 'Matthias'),
      FactoryGirl.create(:request, topic_of_workshop: @topic_of_workshop)
    ]
    assign(:requests, @requests)
  end

  it "renders a list of requests with their attributes" do
    render
    @requests.each do |r|
      assert_select "tr" do
        assert_select 'td>a', :text => r.topic_of_workshop
        assert_select 'td', :text => r.name
        assert_select 'td', :text => r.time_period
        assert_select 'td', :text => r.number_of_participants.to_s
      end
    end

  end

  it "should not display the new button for non-pupils" do
    render
    expect(rendered).to_not have_link(I18n.t('helpers.links.new'))
  end

  it "should display edit, delete buttons for organizers and coaches" do
    [:organizer, :coach].each do |role|
      sign_in(FactoryGirl.create(:user, role: role))
      render

      expect(rendered).to have_link(I18n.t('helpers.links.edit'))
      expect(rendered).to have_link(I18n.t('helpers.links.destroy'))
    end
  end
end
