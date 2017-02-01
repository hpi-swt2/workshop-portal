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
  it "should only show the register now button to non-logged in users" do
    btn_text = I18n.t 'start_page.register_now'

    visit root_path
    expect(page).to have_text(btn_text)

    login_as(FactoryGirl.create(:user), :scope => :user)

    visit root_path
    expect(page).to_not have_text(btn_text)
  end
end

