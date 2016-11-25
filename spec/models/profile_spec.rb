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

  it "is created by user factory" do
    profile = FactoryGirl.create(:profile)
    expect(profile).to be_valid
  end

  it "cannot create Profile without user" do
    profile = FactoryGirl.build(:profile, user: nil)
    expect(profile).to_not be_valid
  end

  it "cannot create Profile without mandatory fields" do
  	[:first_name, :last_name, :gender, :birth_date, :email, :school, :street_name, :zip_code, :city, :state, :country].each do |attr|
	    profile = FactoryGirl.build(:profile, attr => nil)
	    expect(profile).to_not be_valid
	  end
  end

  it "returns correct age" do
    profile = FactoryGirl.build(:profile)
    expect(profile.age).to eq(15)
  end

  it "returns full name" do
    profile = FactoryGirl.build(:profile)
    expect(profile.name).to eq("Karl Doe")
  end
end
