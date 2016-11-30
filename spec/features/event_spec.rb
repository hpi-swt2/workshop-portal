require "rails_helper"

describe "Event", type: :feature do
  describe "create page" do
    ['Camp', 'Workshop'].each do |kind|
      it "should allow picking the #{kind} kind camp" do
        visit new_event_path
        fill_in "Maximale Bewerber", :with => 25
        choose(kind)
        click_button "Veranstaltung erstellen"
        expect(page).to have_text(kind)
      end
    end
  end

  describe "show page" do
    it "should display the event kind" do
      %i[camp workshop].each do |kind|
        event = FactoryGirl.create(:event, kind: kind)
        visit event_path(event)
        expect(page).to have_text(kind.to_s.humanize)
      end
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

