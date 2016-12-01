require 'rails_helper'

RSpec.describe "application_letters/new", type: :view do
  before(:each) do
    assign(:application_letter, FactoryGirl.build(:application_letter))
  end

  it "renders new application form" do
    render

    assert_select "form[action=?][method=?]", application_letters_path, "post" do
      assert_select "textarea#application_letter_motivation[name=?]", "application_letter[motivation]"
      assert_select "textarea#application_letter_experience[name=?]", "application_letter[experience]"
      assert_select "textarea#application_letter_coding_skills[name=?]", "application_letter[coding_skills]"
      assert_select "input#application_letter_emergency_number[name=?]", "application_letter[emergency_number]"
      assert_select "input#application_letter_vegeterian[name=?]", "application_letter[vegeterian]"
      assert_select "input#application_letter_vegan[name=?]", "application_letter[vegan]"
      assert_select "input#application_letter_allergic[name=?]", "application_letter[allergic]"
      assert_select "input#application_letter_allergies[name=?]", "application_letter[allergies]"
      assert_select "input#application_letter_grade[name=?]", "application_letter[grade]"
    end
  end
end
