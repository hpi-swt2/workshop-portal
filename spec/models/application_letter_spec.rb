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
    [:motivation, :emergency_number, :vegetarian, :vegan, :organisation].each do |attr|
      application = FactoryGirl.build(:application_letter, attr => nil)
      expect(application).to_not be_valid
    end
  end

  it "has application_notes" do
    application = FactoryGirl.build(:application_letter)
    expect(application).to respond_to(:application_notes)
  end

 it "returns an empty array when no eating habits exist" do
    application = FactoryGirl.build(:application_letter)
    application.vegan = false
    application.vegetarian = false
    application.allergies = ""
    expect(application.eating_habits).to eq([])
  end

  it "returns a single eating habit" do
    application = FactoryGirl.build(:application_letter)
    application.vegan = true
    application.vegetarian = false
    application.allergies = ""
    expect(application.eating_habits).to eq([ApplicationLetter.human_attribute_name(:vegan)])
  end

  it "returns multiple eating habits" do
    application = FactoryGirl.build(:application_letter)
    application.vegan = false
    application.vegetarian = true
    application.allergies = "many"
    expect(application.eating_habits).to eq([ApplicationLetter.human_attribute_name(:vegetarian), ApplicationLetter.human_attribute_name(:allergies)])
  end

  it "can not be updated after event application deadline"  do
    application = FactoryGirl.build(:application_letter)
    %i[in_selection_phase_with_no_mails_sent in_execution_phase].each do | phase |
      application.event = FactoryGirl.create(:event, phase)
      expect(application).to_not be_valid
    end
  end

  %i[accepted canceled alternative pending].each do | new_status |
    it "cannot update the status in execution phase from rejected into #{new_status}" do
      application = FactoryGirl.create(:application_letter_rejected)
      application.event = FactoryGirl.create(:event, :in_execution_phase)
      application.status = new_status
      expect(application).to_not be_valid
    end
  end

  it "can be canceled (only) if it was accepted before in execution phase" do
    application = FactoryGirl.create(:application_letter_accepted)
    application.event = FactoryGirl.create(:event, :in_execution_phase)
    %i[accepted alternative pending rejected].each do | new_status |
      application.status = new_status
      expect(application).to_not be_valid
    end
    application.status = :canceled
    expect(application).to be_valid
  end

  it "can be promoted to accepted if it was alternative before in execution phase" do
    application = FactoryGirl.create(:application_letter_alternative)
    application.event = FactoryGirl.create(:event, :in_execution_phase)
    %i[alternative canceled pending rejected].each do | new_status |
      application.status = new_status
      expect(application).to_not be_valid
    end
    application.status = :accepted
    expect(application).to be_valid
  end

  it "can update the status in selection phase" do
    application = FactoryGirl.build(:application_letter)
    application.event = FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent)
    application.status = :rejected
    expect(application).to be_valid
  end

  it "can not be updated if status is changed and participant selection is locked" do
    application = FactoryGirl.build(:application_letter)
    %i[in_selection_phase_with_participants_locked in_execution_phase].each do |phase|
      application.event = FactoryGirl.create(:event, phase)
      expect(application.event.participant_selection_locked).to be(true)
      application.status = :rejected
      expect(application).to_not be_valid
    end
  end

  it "can be updated if status is changed and participant selection is not locked" do
    application = FactoryGirl.build(:application_letter_deadline_over)
    application.event.acceptances_have_been_sent = false
    application.event.rejections_have_been_sent = false
    expect(application.event.participant_selection_locked).to be(false)
    application.status = :rejected
    expect(application).to be_valid
  end

  it "can be updated if status is changed"  do
     application = FactoryGirl.build(:application_letter_deadline_over)
     application.status = :rejected
     expect(application).to be_valid
  end

  it "calculates the correct age of applicant when event starts" do
    user = FactoryGirl.build(:user_with_profile)
    application = FactoryGirl.build(:application_letter, user: user)
    application.user.profile.birth_date = application.event.start_date - 18.years
    expect(application.user.profile.age_at_time(application.event.start_date)).to eq(18)
    application.user.profile.birth_date = application.event.start_date - 18.years + 1.day
    expect(application.user.profile.age_at_time(application.event.start_date)).to eq(17)
  end
end
