require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders attributes" do
    render
    [:first_name, :last_name, :birth_date, :street_name, :zip_code, :city, :state, :country, :discovery_of_site].each do |attr_name|
      expect(rendered).to have_text(@profile.public_send(attr_name))
    end
  end
end
