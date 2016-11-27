# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

describe Event do

  it "is created by event factory" do
    event = FactoryGirl.build(:event)
    expect(event).to be_valid
  end

  it "checks if there are unclassified applications_letters" do
    event = FactoryGirl.create(:event)
    acceptedApplicationLetter = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => true)
    event.application_letters.push(acceptedApplicationLetter)
    expect(event.applicationsClassified?).to eq(true)

    rejectedApplicationLetter = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => nil)
    event.application_letters.push(rejectedApplicationLetter)
    expect(event.applicationsClassified?).to eq(false)
  end
end
