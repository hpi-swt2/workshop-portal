require 'rails_helper'

RSpec.describe "applications/new", type: :view do
  before(:each) do
    assign(:application, Application.new(
      :motivation => "MyString",
      :user => nil,
      :workshop => nil
    ))
  end

  it "renders new application form" do
    render

    assert_select "form[action=?][method=?]", applications_path, "post" do

      assert_select "input#application_motivation[name=?]", "application[motivation]"

      assert_select "input#application_user_id[name=?]", "application[user_id]"

      assert_select "input#application_workshop_id[name=?]", "application[workshop_id]"
    end
  end
end
