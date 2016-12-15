# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
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
    [:first_name, :last_name, :gender, :birth_date, :school, :street_name, :zip_code, :city, :state, :country].each do |attr|
      profile = FactoryGirl.build(:profile, attr => nil)
      expect(profile).to_not be_valid
    end
  end

  it "returns correct age" do
    @age = 20
    profile = FactoryGirl.build(:profile, birth_date: @age.years.ago())

    expect(profile.age).to eq(@age)
  end

  it "returns correct age in leap year edge case" do
    # Mock Date today method to return fixed (non leap year) date
    allow(Time).to receive(:now).and_return(Time.new(2017, 2, 28))
    # Birthday on leap year
    profile = FactoryGirl.build(:profile, birth_date: Time.new(1996, 2, 29))

    expect(profile.age).to eq(20)
  end

  it "returns full name" do
    profile = FactoryGirl.build(:profile)
    expect(profile.name).to eq("#{profile.first_name} #{profile.last_name}")
  end

  it "returns full address" do
    profile = FactoryGirl.build(:profile)
    expect(profile.address).to eq("#{profile.street_name}, #{profile.zip_code} #{profile.city}, #{profile.state}, #{profile.country}")
  end

  it "doesn't allow a birthday in the future" do
    profile = FactoryGirl.build(:profile, birth_date: Date.tomorrow)
    expect(profile).to_not be_valid
  end
end
