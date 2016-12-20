require 'rails_helper'

RSpec.describe "profiles/index", type: :feature do
  before(:each) do
    @profile = FactoryGirl.create(:profile)
    @profiles = Profile.all
  end
  it "shows the right values for a logged in admin" do
    @profile.user.role = :admin
    @profile.user.name = "Karl Doe"
    user = @profile.user
    puts user.role
    login_as(user)
    visit profiles_path
    expect(page).to have_text(@profile.id)
    expect(page).to have_selector("#a", :text => user.name)
    expect(page).to have_text(@profile.created_at)
    expect(page).to have_selector("#select", :text => user.role)
    expect(page).to have_button("Save")
  end


end
