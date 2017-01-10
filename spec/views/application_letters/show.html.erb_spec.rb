require 'rails_helper'

RSpec.describe "application_letters/show", type: :view do
  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
    @application_note = assign(:application_note, FactoryGirl.create(:application_note, application_letter: @application_letter))
    @application_letter.user.profile = FactoryGirl.build(:profile)
    render
  end

  it "renders application's attributes" do
    expect(rendered).to have_text(@application_letter.event.name)
    expect(rendered).to have_text(@application_letter.motivation)
  end

  it "renders applicant's attributes" do
    expect(rendered).to have_text(@application_letter.user.profile.name)
    expect(rendered).to have_text(@application_letter.user.profile.gender)
    expect(rendered).to have_text(@application_letter.user.profile.age_at_time(@application_letter.event.start_date))
    expect(rendered).to have_text(@application_letter.user.accepted_applications_count(@application_letter.event))
    expect(rendered).to have_text(@application_letter.user.rejected_applications_count(@application_letter.event))
  end

  %i[coach organizer].each do |role|
    it "logged in as #{role} I cannot see personal details" do
      login(role)
      expect(rendered).to_not have_text(@application_letter.user.profile.address)
      expect(rendered).to_not have_text(@application_letter.user.profile.school)
    end
  end

  it "logged in as admin I can see personal details" do
    login(:admin)
    expect(rendered).to have_text(@application_letter.user.profile.address)
  end

  %i[organizer admin].each do |role|
    it "logged in as #{role} I can click on the applicants name" do
      login(role)
      expect(rendered).to have_link(@application_letter.user.profile.name, :href => profile_path(@application_letter.user))
    end
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
