require 'rails_helper'

RSpec.describe "application_letters/new", type: :view do
  before(:each) do
    @application_letter = FactoryGirl.build(:application_letter)
    assign(:application_letter, @application_letter)
  end

  it "renders new application form" do
    render

    assert_select "form[action=?][method=?]", application_letters_path, "post" do
      assert_select "textarea#application_letter_motivation[name=?]", "application_letter[motivation]"
      assert_select "textarea#application_letter_experience[name=?]", "application_letter[experience]"
      assert_select "textarea#application_letter_coding_skills[name=?]", "application_letter[coding_skills]"
      assert_select "input#application_letter_emergency_number[name=?]", "application_letter[emergency_number]"
      assert_select "input#application_letter_vegetarian[name=?]", "application_letter[vegetarian]"
      assert_select "input#application_letter_vegan[name=?]", "application_letter[vegan]"
      assert_select "input#application_letter_allergic[name=?]", "application_letter[allergic]"
      assert_select "textarea#application_letter_allergies[name=?]", "application_letter[allergies]"
      assert_select "select#application_letter_grade[name=?]", "application_letter[grade]"
      @application_letter.event.custom_application_fields.each { |field_name|
        assert_select "label.control-label[for=custom_application_fields_]", field_name
      }
      assert_select "input#custom_application_fields_", count: @application_letter.event.custom_application_fields.count
    end
  end

end
