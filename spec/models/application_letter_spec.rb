# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  event_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe ApplicationLetter do

  it "is created by application_letter factory" do
    application = FactoryGirl.build(:application_letter)
    expect(application).to be_valid
  end

  it "can't be created without mandatory fields" do
    [:grade, :experience, :motivation, :coding_skills, :emergency_number, :vegetarian, :vegan, :allergic].each do |attr|
      application = FactoryGirl.build(:application_letter, attr => nil)
      expect(application).to_not be_valid
    end
  end

  it "does only accept valid grades" do
    application = FactoryGirl.build(:application_letter, :grade => 8)
    expect(application).to be_valid

    application = FactoryGirl.build(:application_letter, :grade => "erste")
    expect(application).to_not be_valid

    application = FactoryGirl.build(:application_letter, :grade => 4)
    expect(application).to_not be_valid

    application = FactoryGirl.build(:application_letter, :grade => 14)
    expect(application).to_not be_valid
  end

  it "has application_notes" do
    application = FactoryGirl.build(:application_letter)
    expect(application).to respond_to(:application_notes)
  end

 it "returns an empty array when no eating habits exist" do
    application = FactoryGirl.build(:application_letter)
    application.vegan = false
    application.vegetarian = false
    application.allergic = false
    expect(application.eating_habits).to eq([])
  end

  it "returns a single eating habit" do
    application = FactoryGirl.build(:application_letter)
    application.vegan = true
    application.vegetarian = false
    application.allergic = false
    expect(application.eating_habits).to eq([ApplicationLetter.human_attribute_name(:vegan)])
  end

  it "returns multiple eating habits" do
    application = FactoryGirl.build(:application_letter)
    application.vegan = false
    application.vegetarian = true
    application.allergic = true
    expect(application.eating_habits).to eq([ApplicationLetter.human_attribute_name(:vegetarian), ApplicationLetter.human_attribute_name(:allergic)])
  end

  it "can not be updated after event application deadline"  do
    application = FactoryGirl.build(:application_letter_deadline_over)
    expect(application).to_not be_valid
  end

  it "can not be updated if status is changed and application status is locked" do
    application = FactoryGirl.build(:application_letter)
    application.status = :rejected
    application.event.application_status_locked = true
    expect(application).to_not be_valid
  end

  it "can be updated if status is changed and application status is not locked" do
    application = FactoryGirl.build(:application_letter_deadline_over)
    application.status = :rejected
    application.event.application_status_locked = false
    expect(application).to be_valid
  end

  it "can be updated if status is changed"  do
     application = FactoryGirl.build(:application_letter_deadline_over)
     application.status = :rejected
     expect(application).to be_valid
  end

  it "calculates the correct age of applicant when event starts" do
    user = FactoryGirl.build(:user)
    profile = FactoryGirl.build(:profile, user: user)
    application = FactoryGirl.build(:application_letter, user: user)
    application.user.profile.birth_date = application.event.start_date - 18.years
    expect(application.user.profile.age_at_time(application.event.start_date)).to eq(18)
    application.user.profile.birth_date = application.event.start_date - 18.years + 1.day
    expect(application.user.profile.age_at_time(application.event.start_date)).to eq(17)
  end
end
