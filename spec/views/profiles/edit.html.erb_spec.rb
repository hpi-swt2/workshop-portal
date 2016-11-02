require 'rails_helper'

RSpec.describe "profiles/edit", type: :view do
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

  it "renders the edit profile form" do
    render

    assert_select "form[action=?][method=?]", profile_path(@profile), "post" do

      assert_select "input#profile_cv[name=?]", "profile[cv]"

      assert_select "input#profile_user_id[name=?]", "profile[user_id]"
    end
  end
end
