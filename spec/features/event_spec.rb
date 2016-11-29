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

  describe "show page" do
    it "should display the event kind" do
      event = FactoryGirl.create(:event, kind: :workshop)
      visit event_path(event)
      expect(page).to have_text('Workshop')

      event = FactoryGirl.create(:event, kind: :camp)
      visit event_path(event)
      expect(page).to have_text('Camp')
    end
  end

  describe "edit page" do
    it "should preselect the event kind" do
      event = FactoryGirl.create(:event, kind: :camp)
      visit edit_event_path(event)
      expect(find_field('Camp')[:checked]).to_not be_nil
    end
  end
end

