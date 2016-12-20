require 'rails_helper'

RSpec.describe "profiles/index", type: :view do
  before(:each) do
    @profile = FactoryGirl.create(:profile)
    @profiles = Profile.all
  end

  it "has the correct header fields" do
    render
    expect(rendered).to have_selector('th', :text => "Id")
    expect(rendered).to have_selector('th', :text => "User")
    expect(rendered).to have_selector('th', :text => "Created at")
    expect(rendered).to have_selector('th', :text => "Aktionen")
    expect(rendered).to have_selector('th', :text => "Role")
    
  end
end
