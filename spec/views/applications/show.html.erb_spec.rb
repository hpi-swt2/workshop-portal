require 'rails_helper'

RSpec.describe "applications/show", type: :view do
  before(:each) do
    @application = assign(:application, Application.create!(
      :motivation => "Motivation",
      :user => nil,
      :workshop => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Motivation/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
