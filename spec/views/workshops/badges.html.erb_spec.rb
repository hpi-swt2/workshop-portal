require 'rails_helper'

RSpec.describe "workshops/badges", type: :view do
  before(:each) do
    @workshop = assign(:workshop, FactoryGirl.create(:workshop))
  end

  it "renders the print badges workshop page" do
    render
    assert_select "h1", :text => "Print name badges for workshop '" + @workshop.name + "'"
  end

  it "renders the generate pdf button" do
    render
    assert_select "button", :text => 'generate PDF'
  end
end
