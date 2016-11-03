require 'rails_helper'

RSpec.describe "workshops/edit", type: :view do
  before(:each) do
    @workshop = assign(:workshop, Workshop.create!(
      :name => "MyString",
      :description => "MyString",
      :max_participants => 1,
      :active => false
    ))
  end

  it "renders the edit workshop form" do
    render

    assert_select "form[action=?][method=?]", workshop_path(@workshop), "post" do

      assert_select "input#workshop_name[name=?]", "workshop[name]"

      assert_select "input#workshop_description[name=?]", "workshop[description]"

      assert_select "input#workshop_max_participants[name=?]", "workshop[max_participants]"

      assert_select "input#workshop_active[name=?]", "workshop[active]"
    end
  end
end
