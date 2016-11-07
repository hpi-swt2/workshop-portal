require 'rails_helper'

RSpec.describe "requests/show", type: :view do
  before(:each) do
    @request = assign(:request, FactoryGirl.create(:request, topics: 'Topics'))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@request.topics)
  end
end
