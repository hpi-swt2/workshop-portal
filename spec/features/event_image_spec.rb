require "rails_helper"
require "event_image_upload_helper"
include ActionView::Helpers::AssetUrlHelper
include EventImageUploadHelper

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
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t(".events.form.create")
    end

    it "should not allow uploading images that are too small" do
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/too_small_image.png')
      click_button I18n.t(".events.form.create")
      expect(page).to have_css('.has-error', text: I18n.t("events.errors.image_too_small"))
    end

    it "should allow picking a stock image" do
      image = stock_photo_path
      choose(path_to_id(image))
      click_button I18n.t(".events.form.create")
      visit edit_event_path(Event.last)
      expect(page).to have_css('.active.btn input', id: path_to_id(image))
    end

    it "should show a custom image in the list, even after selecting a stock image" do
      # got to the new page and upload a custom image
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t(".events.form.create")

      custom_image = Event.last.custom_image
      stock_image = stock_photo_path

      # check that the custom image is set in the overview
      visit events_path
      expect(page).to have_css("img[src='#{image_path(custom_image)}']")

      # check that the custom image is the selected one
      visit edit_event_path(Event.last)
      expect(page).to have_css('.active.btn input', id: custom_image)

      # pick a stock image
      choose(stock_image)
      click_button I18n.t('.events.form.update')

      # check that the stock image is set in the overview
      visit events_path
      expect(page).to have_css("img[src=#{image_path(stock_image)}]")

      # pick the former custom image
      visit edit_event_path(Event.last)
      choose(custom_image)
      click_button I18n.t('.events.form.update')

      # check that the custom image has been selected again
      visit edit_event_path(Event.last)
      expect(page).to have_css('.active.btn input', id: custom_image)
    end

    it "should only have a single custom image, even when a new one is uploaded" do
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t(".events.form.create")

      first_image = image_path(Event.last.custom_image)

      visit edit_event_path(Event.last)
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test2.png')
      click_button I18n.t(".events.form.update")

      second_image = image_path(Event.last.custom_image)

      visit edit_event_path(Event.last)
      expect(page).to_not have_css('.btn input', id: first_image)
      expect(page).to have_css('.btn input', id: second_image)
    end
  end

  # @return [String] path to a stock photo
  def stock_photo_path
    'stock_photos/' +
      Dir.glob(Rails.root + 'app/assets/images/stock_photos/*').first.split('/').last
  end
end

