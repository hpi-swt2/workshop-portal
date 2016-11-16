require 'rails_helper'

RSpec.describe "profiles/edit", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders the edit profile form" do
    render

    assert_select "form[action=?][method=?]", profile_path(@profile), "post" do
      assert_select "input#profile_cv[name=?]", "profile[cv]"
    end
  end
end
