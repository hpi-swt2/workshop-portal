require 'rails_helper'

RSpec.describe "workshops/index", type: :view do
  before(:each) do
    assign(:workshops, [
      Workshop.create!(
        :name => "Name",
        :description => "Description",
        :max_participants => 2,
        :active => false
      ),
      Workshop.create!(
        :name => "Name",
        :description => "Description",
        :max_participants => 2,
        :active => false
      )
    ])
  end

  it "renders a list of workshops" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
