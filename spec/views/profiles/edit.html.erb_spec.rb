require 'rails_helper'

RSpec.describe "profiles/edit", type: :view do
  before(:each) do
    @profile = assign(:profile, FactoryGirl.create(:profile))
  end

  it "renders the edit profile form" do
    render

    assert_select "form[action=?][method=?]", profile_path(@profile), "post" do
      assert_select "input#profile_cv[name=?]", "profile[cv]"
      assert_select "input#profile_user_id[name=?]", "profile[user_id]"
      assert_select "input#profile_first_name[name=?]", "profile[first_name]"
      assert_select "input#profile_last_name[name=?]", "profile[last_name]"
      assert_select "input#profile_gender[name=?]", "profile[gender]"
      assert_select "input#profile_birth_date[name=?]", "profile[birth_date]"
      assert_select "input#profile_email[name=?]", "profile[email]"
      assert_select "input#profile_school[name=?]", "profile[school]"
      assert_select "input#profile_street_name[name=?]", "profile[street_name]"
      assert_select "input#profile_zip_code[name=?]", "profile[zip_code]"
      assert_select "input#profile_city[name=?]", "profile[city]"
      assert_select "input#profile_state[name=?]", "profile[state]"
      assert_select "input#profile_country[name=?]", "profile[country]"
      assert_select "input#profile_graduates_school_in[name=?]", "profile[graduates_school_in]"
    end
  end
  it "contains all required fields " do
      render :template => '/profiles/edit.html.erb'
      expect(rendered).to have_css('.required', minimum: 11)
  end
end
