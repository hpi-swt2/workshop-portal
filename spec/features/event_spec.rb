require "rails_helper"

describe "Event", type: :feature do
  describe "create page" do
    it "should allow picking the event kind camp" do
      visit new_event_path
      fill_in 'Max participants', :with => 25
      choose('Camp')
      click_button "Event erstellen"
      expect(page).to have_text('Camp')
    end

    it "should allow picking the event kind workshop" do
      visit new_event_path
      fill_in 'Max participants', :with => 25
      choose('Workshop')
      click_button "Event erstellen"
      expect(page).to have_text('Workshop')
    end
  end
end

