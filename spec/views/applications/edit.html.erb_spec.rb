require 'rails_helper'

RSpec.describe "applications/edit", type: :view do
  before(:each) do
    @application = assign(:application, Application.create!(
      :motivation => "MyString",
      :user => nil,
      :workshop => nil
    ))
  end

  it "renders the edit application form" do
    render

    assert_select "form[action=?][method=?]", application_path(@application), "post" do

      assert_select "input#application_motivation[name=?]", "application[motivation]"

      assert_select "input#application_user_id[name=?]", "application[user_id]"

      assert_select "input#application_workshop_id[name=?]", "application[workshop_id]"
    end
  end
end
