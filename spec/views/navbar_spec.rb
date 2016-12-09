require 'rails_helper'

RSpec.describe 'navbar', type: :view do

  it "shows Start, Veranstaltungen, Anfragen in the menu" do
    %i[pupil organizer coach admin].each do |role|
      user = FactoryGirl.create(:user, role: role)
      sign_in user
      render template: 'application/index', layout: 'layouts/application'

      expect(rendered).to have_css(".nav a", text: 'Start')
      expect(rendered).to have_css(".nav a", text: 'Veranstaltungen')
      expect(rendered).to have_css(".nav a", text: 'Anfragen')
    end
  end

  context "logged in as pupil without a profile" do
    before(:each) do
      user = FactoryGirl.create(:user, role: :pupil)
      sign_in user
      render template: 'application/index', layout: 'layouts/application'
    end

    it "shows Profilinfo, Mein Profil anlegen, Meine Bewerbungen, Ausloggen in the dropdown" do
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Profilinfo')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Mein Profil anlegen')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Meine Bewerbungen')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Ausloggen')
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 4)
    end
  end

  context "logged in as pupil with a profile" do
    it "shows Mein Profil in the dropdown" do
      profile = FactoryGirl.create(:profile)
      sign_in profile.user
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Mein Profil')
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 4)
    end
  end

  context "logged in as an admin" do
    it "shows Profilinfo, Mein Profil, Benutzerverwaltung, Ausloggen" do
      profile = FactoryGirl.create(:profile, user: (FactoryGirl.create :user, role: :admin))
      sign_in profile.user
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Profilinfo')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Mein Profil')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Benutzerverwaltung')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Ausloggen')
      expect(rendered).to have_css(".nav .dropdown-menu a", count: 4)
    end
  end

  context "logged in as an organizer or coach" do
    %i[organizer coach].each do |role|
      it "shows Profilinfo, Mein Profil, Ausloggen" do
        profile = FactoryGirl.create(:profile, user: (FactoryGirl.create :user, role: role))
        sign_in profile.user
        render template: 'application/index', layout: 'layouts/application'
        expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Profilinfo')
        expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Mein Profil')
        expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Ausloggen')
        expect(rendered).to have_css(".nav .dropdown-menu a", count: 3)
      end
    end
  end
end

