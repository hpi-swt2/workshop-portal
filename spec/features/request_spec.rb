require 'rails_helper'

describe 'workshop requests', type: :feature do
  before(:each) do
    @request = FactoryGirl.create :request
  end

  describe 'create page' do

    def fill_in_required_fields
      fill_in I18n.t('activerecord.attributes.request.first_name'), :with => 'Martina'
      fill_in I18n.t('activerecord.attributes.request.last_name'), :with => 'Mustermann'
      fill_in I18n.t('activerecord.attributes.request.phone_number'), :with => '0123456789'
      fill_in I18n.t('activerecord.attributes.request.street'), :with => 'Musterstraße 3'
      fill_in I18n.t('activerecord.attributes.request.zip_code_city'), :with => '12345 Musterstadt'
      fill_in I18n.t('activerecord.attributes.request.email'), :with => 'martina@mustermann.de'
      fill_in I18n.t('activerecord.attributes.request.topic_of_workshop'), :with => 'Musterthema'
    end

    [I18n.t('requests.form_of_addresses.mr'),
     I18n.t('requests.form_of_addresses.mrs'),
     I18n.t('requests.form_of_addresses.prefer_to_omit')].each do |form_of_address|
      it "should allow picking #{form_of_address} as form of address" do
      	visit new_request_path
      	choose(form_of_address)
      	fill_in_required_fields
      	click_button I18n.t('requests.form.create_request')
      	expect(page).to have_current_path(root_path)
      end
    end
  end

  context "as a user who's not an organizer or coach" do
    it "shouldn't display the index page and show an error" do
      visit requests_path
      expect(page).not_to have_text(@request.topic_of_workshop)
      expect(page).to have_text(I18n.t('unauthorized.manage.all'))

      profile = FactoryGirl.create(:profile)
      pupil = FactoryGirl.create(:user, role: :pupil, profile: profile)
      login_as(pupil, scope: :user)

      visit requests_path
      expect(page).not_to have_text(@request.topic_of_workshop)
      expect(page).to have_text(I18n.t('unauthorized.manage.all'))
    end
  end

  context 'as a coach or organizer' do
    it 'should show the index page' do
      profile = FactoryGirl.create(:profile)
      coach = FactoryGirl.create(:user, role: :coach, profile: profile)
      login_as(coach, scope: :user)
      visit requests_path
      expect(page).to have_text(@request.topic_of_workshop)

      organizer = FactoryGirl.create(:user, role: :organizer, profile: profile)
      login_as(organizer, scope: :user)
      visit requests_path
      expect(page).to have_text(@request.topic_of_workshop)
    end
  end

  describe 'show page' do
    context 'as an organizer' do
      before(:each) do
        profile = FactoryGirl.create(:profile)
        organizer = FactoryGirl.create(:user, role: :organizer, profile: profile)
        login_as(organizer, scope: :user)
      end

      it 'should allow me to change the status to :accepted and display the change' do
        request = FactoryGirl.create(:request, status: :open)
        visit(request_path(request))
        status = I18n.t(@request.status, scope: 'activerecord.attributes.request.statuses')
        expect(page).to have_text(status)
        click_link I18n.t('requests.form.accept')
        expect(page).to have_text(I18n.t('requests.notice.was_accepted'))
        visit(request_path(request))
        accepted_status = I18n.t 'activerecord.attributes.request.statuses.accepted'
        expect(page).to have_text(accepted_status)
      end

      it 'should allow me to enter an contact person' do
        request = FactoryGirl.create(:request)

        visit(request_path(request))
        expect(page).to have_field('request_contact_person')
        fill_in 'request_contact_person', with: 'Me'
        click_button I18n.t('requests.form.set_contact_person')

        visit(request_path(request))
        expect(page).to have_field('request_contact_person', with: 'Me')
      end
    end
  end
end
