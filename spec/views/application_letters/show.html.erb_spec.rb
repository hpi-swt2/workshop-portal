require 'rails_helper'

RSpec.describe "application_letters/show", type: :view do
  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
    @application_letter.user.profile = FactoryGirl.build(:profile)
    render
  end

  it "renders application's attributes" do
    expect(rendered).to have_text(@application_letter.event.name)
    expect(rendered).to have_text(@application_letter.motivation)
  end

  it "renders appllicant's attributes" do
    expect(rendered).to have_text(@application_letter.user.profile.name)
    expect(rendered).to have_text(@application_letter.user.profile.gender)
    expect(rendered).to have_text(@application_letter.user.profile.age)
    expect(rendered).to have_text(@application_letter.user.profile.address)
    expect(rendered).to have_text(@application_letter.user.accepted_application_count)
    expect(rendered).to have_text(@application_letter.user.rejected_application_count)
  end

end
