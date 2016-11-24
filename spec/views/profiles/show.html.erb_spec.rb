require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@profile.cv)
  end

  it "renders the upload form for the letter of agreement" do
    render
    expect(rendered).to have_button(I18n.t('.upload', default: I18n.t("agreement_letters.upload")))
  end
end
