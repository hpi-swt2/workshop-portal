require "rails_helper"

describe "workshop requests", type: :feature do
  before(:each) do
    @request = FactoryGirl.create :request
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
