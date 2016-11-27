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

  it "has notes text area" do
    render
    expect(rendered).to have_selector("textarea", :id => "application_note_note")
  end

  it "shows saved notes" do
    render
    expect(rendered).to have_text(@application_note.note)
  end

  it "renders applicant's attributes" do
    expect(rendered).to have_text(@application_letter.user.profile.name)
    expect(rendered).to have_text(@application_letter.user.profile.gender)
    expect(rendered).to have_text(@application_letter.user.profile.age)
    expect(rendered).to have_text(@application_letter.user.profile.address)
    expect(rendered).to have_text(@application_letter.user.accepted_applications_count(@application_letter.event))
    expect(rendered).to have_text(@application_letter.user.rejected_applications_count(@application_letter.event))
  end

end
