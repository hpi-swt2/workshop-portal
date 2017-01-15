require "rails_helper"

describe "workshop requests", type: :feature do
  before(:each) do
    @request = FactoryGirl.create :request
  end

  describe "create page" do

    def fill_in_required_fields
      fill_in "Vorname", :with => "Martina"
      fill_in "Nachname", :with => "Mustermann"
      fill_in "Telefonnummer", :with => "0123456789"
      fill_in "Straße und Hausnummer", :with => "Musterstraße 3"
      fill_in "PLZ und Stadt", :with => "12345 Musterstadt"
      fill_in "E-Mail-Adresse", :with => "martina@mustermann.de"
      fill_in "Thema des Workshops", :with => "Musterthema"
    end

    ['Herr', 'Frau', 'Nicht angeben'].each do |form_of_address|
      it "should allow picking #{form_of_address} kind form of address" do
      	visit new_request_path
      	choose(form_of_address)
      	fill_in_required_fields
      	click_button I18n.t('.requests.form.create_request')
      	expect(page).to have_current_path(request_path(Request.last))
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

  context "as a coach or organizer" do
    it "should show the index page" do
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
end
