require "rails_helper"

describe "Start page", type: :feature do
  it "should not show drafts to anyone" do
    %i[coach admin organizer pupil].each do |role|
      login_as(FactoryGirl.create(:user, role: role), :scope => :user)

      FactoryGirl.create :event, published: false
      visit root_path
      expect(page).to_not have_css(".label", text: I18n.t(".activerecord.attributes.event.draft"))
    end
  end
end

