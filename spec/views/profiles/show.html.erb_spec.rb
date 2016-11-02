require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, Profile.create!(
        :cv => "MyString",
        :user => User.create!(
            email: "bla@keks.de",
            name: "Bla Keks",
            password: "123456"
        )
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Cv/)
    expect(rendered).to match(//)
  end
end
