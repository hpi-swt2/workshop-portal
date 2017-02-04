require 'rails_helper'

RSpec::Steps.steps "Demo" do
  it "should show the global title" do
    visit root_path
    page.should have_text "Workshop"
  end
end