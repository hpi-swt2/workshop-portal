require "rails_helper"

describe "Event pictures", type: :feature do
  describe "new event" do
    before :each do
      visit new_event_path
      fill_in "Maximale Teilnehmerzahl", :with => 25
      fill_in "event[date_ranges_attributes][][start_date]", :with => I18n.l(Date.tomorrow.next_day(2))
      fill_in "event[date_ranges_attributes][][end_date]", :with => I18n.l(Date.tomorrow.next_day(3))
      fill_in "event_application_deadline", :with => I18n.l(Date.tomorrow)
    end

    it "should allow uploading images" do
      attach_file "Bild", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t(".events.form.create")
    end

    it "should not allow uploading images that are too small" do
      attach_file "Bild", File.join(Rails.root + 'spec/testfiles/too_small_image.png')
      click_button I18n.t(".events.form.create")
      expect(page).to have_text(I18n.t "events.errors.image_too_small")
    end
  end
end

