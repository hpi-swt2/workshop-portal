require 'rails_helper'
require 'event_image_upload_helper'

describe 'Event pictures', type: :feature do
  include ActionView::Helpers::AssetUrlHelper
  include EventImageUploadHelper

  describe 'new event' do
    before :each do
      login_as(FactoryGirl.create(:user, role: :organizer), :scope => :user)
      visit new_event_path
      fill_in 'event_name', :with => 'Test Name'
      fill_in 'event_description', :with => 'Loooong test description with helpful information'
      fill_in 'Maximale Teilnehmerzahl', :with => 25
      fill_in "event[date_ranges_attributes][][start_date]", :with => I18n.l(Date.tomorrow.next_day(2))
      fill_in "event[date_ranges_attributes][][end_date]", :with => I18n.l(Date.tomorrow.next_day(3))
      fill_in 'event_application_deadline', :with => I18n.l(Date.tomorrow)
    end

    it 'should correctly set an image even if first validation fails' do
      fill_in 'Maximale Teilnehmerzahl', :with => nil
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t 'events.form.draft.publish'

      fill_in 'Maximale Teilnehmerzahl', :with => 25
      click_button I18n.t('events.form.draft.publish')
      expect(Event.last.image).to be_present
    end

    it 'should not change the image if validation for a new image fails' do
      click_button I18n.t('events.form.draft.publish')
      previous_image = Event.last.image

      visit edit_event_path(Event.last)
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/too_small_image.png')
      click_button 'update'

      expect(Event.last.image).to eq(previous_image)
      # assert that our invalid image wasn't added as an option
      expect(page).to have_css('.image-buttons .btn', count: stock_photo_paths.count)
    end

    it 'should allow uploading images' do
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t 'events.form.draft.publish'
    end

    it 'should not allow uploading images that are too small' do
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/too_small_image.png')
      click_button I18n.t 'events.form.draft.publish'
      expect(page).to have_css('.has-error', text: I18n.t('events.errors.image_too_small'))
    end

    it 'should allow picking a stock image' do
      image = stock_photo_path
      choose(path_to_id(image))
      click_button I18n.t 'events.form.draft.publish'
      visit edit_event_path(Event.last)
      expect(page).to have_css('.active.btn input', id: path_to_id(image))
    end

    it 'should preselect a stock image' do
      click_button I18n.t 'events.form.draft.publish'
      expect(Event.last.image).to be_present
    end

    it 'should show a custom image in the list, even after selecting a stock image' do
      # got to the new page and upload a custom image
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t 'events.form.draft.publish'

      custom_image = Event.last.custom_image_url(:list_view)
      stock_image = stock_photo_path

      # check that the custom image is set in the overview
      visit events_path
      expect(page).to have_css("img[src='#{image_path(custom_image)}']")

      # check that the custom image is the selected one
      visit edit_event_path(Event.last)
      expect(page).to have_css('.active.btn input', id: path_to_id(custom_image))

      # pick a stock image
      choose(path_to_id(stock_image))
      click_button I18n.t('events.form.update')

      # we can't check on the view directly due to post-processing of assets with
      # sprockets, which changes the image paths. the tests don't get this processing
      # which results in the paths that are displayed on the view not being the same
      # one would expect from within rspec. as a workaround we check the model instead
      expect(Event.last.image).to eq(stock_image)

      # pick the former custom image
      visit edit_event_path(Event.last)
      choose(path_to_id(custom_image))
      click_button I18n.t('events.form.update')

      # check that the custom image has been selected again
      visit edit_event_path(Event.last)
      expect(page).to have_css('.active.btn input', id: path_to_id(custom_image))
    end

    it 'should only have a single custom image, even when a new one is uploaded' do
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test.png')
      click_button I18n.t 'events.form.draft.publish'

      first_image = Event.last.custom_image_url(:list_view)

      visit edit_event_path(Event.last)
      attach_file "event[custom_image]", File.join(Rails.root + 'spec/testfiles/image_upload_test2.png')
      click_button I18n.t('events.form.update')

      second_image = image_path(Event.last.custom_image_url(:list_view))

      visit edit_event_path(Event.last)
      expect(page).to_not have_css('.btn input', id: path_to_id(first_image))
      expect(page).to have_css('.btn input', id: path_to_id(second_image))
    end
  end

  # @return [String] path to a stock photo
  def stock_photo_path
    stock_photo_paths.first
  end
end
