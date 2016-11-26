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

  it "returns correct default accepted applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.accepted_applications_count).to eq(0)
  end

  it "returns correct default rejected applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.rejected_applications_count).to eq(0)
  end

  it "only counts the accepted application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter, user: user, event: other_event, status: true)
    current_application_letter = FactoryGirl.create(:application_letter, user: user, event: current_event, status: true)

    expect(current_application_letter.accepted_applications_count).to eq(1)
  end

  it "only counts the rejected application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter, user: user, event: other_event, status: false)
    current_application_letter = FactoryGirl.create(:application_letter, user: user, event: current_event, status: false)

    expect(current_application_letter.rejected_applications_count).to eq(1)
  end
end
