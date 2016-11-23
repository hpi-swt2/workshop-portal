require 'rails_helper'

RSpec.describe "application_letters/show", type: :view do
  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
    @application_note = assign(:application_note, FactoryGirl.create(:application_note, application_letter: @application_letter))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@application_letter.motivation)
  end

  it "has notes text area" do
    render
    expect(rendered).to have_selector("textarea", :id => "application_note_note")
  end
end
