require 'rails_helper'

RSpec.describe "application_letters/show", type: :view do
  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@application_letter.motivation)
  end
end
