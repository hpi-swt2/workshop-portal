require 'rails_helper'

RSpec.describe 'navbar', type: :view do

  context "logged in as pupil without a profile" do
    before(:each) do
      user = FactoryGirl.create(:user, role: :pupil)
      sign_in user
      render template: 'application/index', layout: 'layouts/application'
    end

    it "shows Start, Veranstaltungen, Anfragen in the menu" do
      expect(rendered).to have_css(".nav a", text: 'Start')
      expect(rendered).to have_css(".nav a", text: 'Veranstaltungen')
      expect(rendered).to have_css(".nav a", text: 'Anfragen')
    end

    it "shows Profilinfo, Meine Bewerbungen, Ausloggen in the dropdown" do
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Profilinfo')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Meine Bewerbungen')
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Ausloggen')
    end

    it "shows no profile link" do
      expect(rendered).to_not have_css(".nav .dropdown-menu a", text: 'Mein Profil')
    end
  end

  context "logged in as pupil with a profile" do
    it "shows Mein Profil in the dropdown" do
      profile = FactoryGirl.create(:profile)
      sign_in profile.user
      render template: 'application/index', layout: 'layouts/application'
      expect(rendered).to have_css(".nav .dropdown-menu a", text: 'Mein Profil')
    end
  end
end

