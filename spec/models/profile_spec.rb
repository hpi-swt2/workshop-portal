# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  cv         :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Profile do

  it "cannot create Profile without user" do
    profile = FactoryGirl.build(:profile, user: nil)
    expect(profile).to_not be_valid
  end

  it "dummy test sets name, please add real tests" do
    profile = FactoryGirl.create(:profile)
    profile.cv = "new cv"
    expect(profile.cv).to eq("new cv")
  end

end
