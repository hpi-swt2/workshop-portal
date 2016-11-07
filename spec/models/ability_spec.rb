require 'rails_helper'
# Allow using cancan helpers in tests
# https://github.com/ryanb/cancan/wiki/Testing-Abilities
require "cancan/matchers"

describe User do

  it "can edit its profile" do
    user = FactoryGirl.create(:user)
    profile = FactoryGirl.create(:profile, user: user)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:edit, profile) 
  end

  it "cannot edit another user's profile" do
    user = FactoryGirl.create(:user)
    another_user = FactoryGirl.create(:user)
    another_profile = FactoryGirl.create(:profile, user: another_user)
    ability = Ability.new(user)

    expect(ability).to_not be_able_to(:edit, another_profile) 
  end
end
