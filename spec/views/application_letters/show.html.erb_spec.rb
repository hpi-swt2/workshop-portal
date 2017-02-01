require 'rails_helper'
require 'request_helper'

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
    expect(rendered).to have_text(@application_letter.annotation)
  end

  it "renders applicant's attributes" do
    expect(rendered).to have_text(@application_letter.user.profile.name)
    expect(rendered).to have_text(@application_letter.user.profile.gender)
    expect(rendered).to have_text(@application_letter.user.profile.age_at_time(@application_letter.event.start_date))
    expect(rendered).to have_text(@application_letter.user.accepted_applications_count(@application_letter.event))
    expect(rendered).to have_text(@application_letter.user.rejected_applications_count(@application_letter.event))
  end
end
