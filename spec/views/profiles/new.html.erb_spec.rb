require 'rails_helper'

RSpec.describe "profiles/new", type: :view do
  before(:each) do
    assign(:profile, FactoryGirl.build(:profile))
  end

  it "renders new profile form" do
    render

    assert_select "form[action=?][method=?]", profiles_path, "post" do
      assert_select "input#profile_first_name[name=?]", "profile[first_name]"
    end
  end
end
