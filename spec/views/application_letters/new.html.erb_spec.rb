require 'rails_helper'

RSpec.describe "application_letters/new", type: :view do
  before(:each) do
    assign(:application_letter, FactoryGirl.build(:application_letter))
  end

  it "renders new application form" do
    render

    assert_select "form[action=?][method=?]", application_letters_path, "post" do
      assert_select "input#application_letter_motivation[name=?]", "application_letter[motivation]"
      assert_select "input#application_letter_workshop_id[name=?]", "application_letter[workshop_id]"
    end
  end
end
