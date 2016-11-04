require 'rails_helper'

describe Profile do

  it "cannot create Profile without user" do
    profile = Profile.new(cv: "The CV");
    expect(profile).to_not be_valid
  end

  it "dummy test sets name, please add real tests" do
    profile = Profile.create!(user: FactoryGirl.create(:user), cv: "This is the cv")
    profile.cv = "new cv"
    expect(profile.cv).to eq("new cv")
  end

end