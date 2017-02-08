require "rails_helper"

RSpec.feature "Material area on event page", :type => :feature, :js => true do
  before :each do
    @event = FactoryGirl.create(:event)
  end

  def mock_writing_to_filesystem
    Dir.mktmpdir do |dir|
      # add extra level to clean up after simulated directory traversal attack
      subdir = File.join(dir, "testdir")
      Dir.mkdir(subdir)
      allow_any_instance_of(Event).to receive(:material_path).and_return(subdir)
      yield
    end
  end

  scenario "logged in as Organizer I can upload an file to the materials and delete it", js: false do
    mock_writing_to_filesystem do
      login(:organizer)
      visit event_path(@event)
      attach_file("material_upload_#{@event.id}", File.join(Rails.root, 'spec/testfiles/actual.pdf'))
      click_button I18n.t "events.material_area.upload"
      expect(page).to have_button('actual.pdf')
      click_button "material_remove_btn_#{@event.id}_actual.pdf"
      expect(page).to_not have_button('actual.pdf')
    end
  end

  scenario "logged in as Organizer I can create and rename a directory", js: true do
    mock_writing_to_filesystem do
      login(:organizer)
      visit event_path(@event)
      find('#root-dir-btn').click
      expect(find("#material_sub_dir_path", :visible => false).value).to eq ''
      fill_in :name, with: "test_dir"
      click_button I18n.t "events.material_sub_dir_modal.submit"
      expect(page).to have_button('test_dir')
      page.all('.rename-dir-button')[0].click
      expect(find("#material_rename_path", :visible => false).value).to eq 'test_dir'
      fill_in :to, with: "my_new_name"
      click_button I18n.t "events.material_rename_modal.submit"
      expect(page).to_not have_button('test_dir')
      expect(page).to have_button('my_new_name')
    end
  end


  scenario "logged in as Organizer I can create a directory, create another directory and move it into the directory" do
    mock_writing_to_filesystem do
      login(:organizer)
      visit event_path(@event)
      find('#root-dir-btn').click
      expect(find("#material_sub_dir_path", :visible => false).value).to eq ''
      fill_in :name, with: "test_dir"
      click_button I18n.t "events.material_sub_dir_modal.submit"
      expect(page).to have_button('test_dir')
      find('#root-dir-btn').click
      expect(find("#material_sub_dir_path", :visible => false).value).to eq ''
      fill_in :name, with: "another_dir"
      click_button I18n.t "events.material_sub_dir_modal.submit"
      expect(page).to have_button('another_dir')
      page.all('.move-dir-button')[0].click
      expect(find("#material_move_path", :visible => false).value).to eq 'another_dir'
      select "/test_dir", :from => I18n.t("events.material_move_modal.to")
      click_button I18n.t "events.material_move_modal.submit"
      expect(page).to have_css('ul li ul li ul li')
    end
  end

  scenario "logged in as Organizer I can download all materials uploaded right now as zip", js: true do
    mock_writing_to_filesystem do
      login(:organizer)
      @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
      visit event_path(@event)
      click_button I18n.t "events.material_area.download_all"
      expect(page.response_headers['Content-Type']).to eq("application/zip")
    end
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
