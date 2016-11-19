require 'rails_helper'

RSpec.describe "workshops/new", type: :view do
  before(:each) do
    assign(:workshop, FactoryGirl.build(:workshop))
  end

  it "renders new workshop form" do
    render

    assert_select "form[action=?][method=?]", workshops_path, "post" do
      assert_select "input#workshop_name[name=?]", "workshop[name]"
      assert_select "input#workshop_description[name=?]", "workshop[description]"
      assert_select "input#workshop_max_participants[name=?]", "workshop[max_participants]"
      assert_select "input#workshop_active[name=?]", "workshop[active]"
      assert_select "input#workshop_organizer[name=?]", "workshop[organizer]"
      assert_select "input#workshop_knowledge_level[name=?]", "workshop[knowledge_level]"
    end
  end
end
