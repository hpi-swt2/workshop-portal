require 'rails_helper'

RSpec.describe 'navbar', type: :view do
  before :each do
    @events = []
  end

  it "shows Veranstaltungen, Anfragen in the menu" do
    %i[pupil organizer coach admin].each do |role|
      user = FactoryGirl.create(:user, role: role)
      sign_in user
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_css(".nav a", text: I18n.t('navbar.events'))
    end
  end

  context "logged in as pupil without a profile" do
    before(:each) do
      user = FactoryGirl.create(:user, role: :pupil)
      sign_in user
      render template: 'application/index', layout: 'layouts/application'
    end

    it "shows Einstellungen, Mein Profil anlegen, Meine Bewerbungen, Ausloggen in the dropdown" do
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.settings'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.create_profile'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.my_application_letters'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.logout'))
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 4)
    end

  end

  context "logged in as pupil with a profile" do
    it "shows Mein Profil in the dropdown" do
      profile = FactoryGirl.create(:profile)
      sign_in profile.user
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.profile'))
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 4)
    end
  end

  context "logged in as an admin or organizer" do
    it "shows Einstellungen, Mein Profil, Benutzerverwaltung, Ausloggen" do
      profile = FactoryGirl.create(:profile, user: (FactoryGirl.create :user, role: :admin))
      sign_in profile.user
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.settings'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.profile'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.user_management'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.logout'))
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 4)
    end
  end

  %i[organizer coach].each do |role|
    context "logged in as #{role}" do
      before(:each) do
        profile = FactoryGirl.create(:profile, user: (FactoryGirl.create :user, role: role))
        sign_in profile.user
        render template: 'application/index', layout: 'layouts/application'
      end

      it "has a link to requests overview" do
        expect(rendered).to have_link(I18n.t('navbar.requests'), :href => requests_path)
      end
    end
  end

  context "logged in as coach" do
    before(:each) do
      profile = FactoryGirl.create(:profile, user: (FactoryGirl.create :user, role: :coach))
      sign_in profile.user
      render template: 'application/index', layout: 'layouts/application'
    end

    it "shows Einstellungen, Mein Profil, Ausloggen" do
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.settings'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.profile'))
      expect(rendered).to have_css(".nav .dropdown-menu a", text: I18n.t('navbar.logout'))
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 3)
    end
  end

  context "not logged in" do
    it "has a link to make a new event request" do
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_link(I18n.t('navbar.new_request'), :href => new_request_path)
    end
  end

end
